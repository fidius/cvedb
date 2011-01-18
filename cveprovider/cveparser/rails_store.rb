module RailsStore
  
  MODIFIED_XML = "nvdcve-2.0-modified.xml"
  
  # We temporarily store the vuln products in a hash to fix duplicates easily.
  # The hash looks like this: { :"vulnerable_software_string" => [ cves ] }
  @products = {}

  def self.create_new_entries xml_file_name, entries
 
    #Check, if XML-File was parsed before. 
    xml_db_entry = Xml.find_by_name(xml_file_name)

    if xml_db_entry and xml_file_name != MODIFIED_XML
      puts "\n#{xml_file_name} is already in the database! Please use 'rake nvd:update' to fetch the most recent updates."
      return
    end    
    
    start_time = Time.now
    puts "[*] Storing the CVE-Entries in DB"
    
    num_entries = entries.size
    
    entries.each_with_index do |entry, index|
      puts "Store: #{entry.cve} [#{index+1}/#{num_entries}]"
      save_entry(entry, true)
    end

    # Until now, the products are only remembered in the @products hash, they
    # are saved when all products are collected so we dont have duplicates
    save_products
    
    params = {:name => xml_file_name, :create_time => Time.now.to_datetime}    
    
    if xml_db_entry
      xml_db_entry.update_attributes(params[:create_time])
    else
      Xml.create(params)      
    end

    total_time = (Time.now - start_time).round
    puts "[*] All Entries & Products stored, this has taken "+
        "#{total_time/60}:#{total_time%60}"
  end
  
  private

  # Stores one entry in the database
  # with_products_hash:
  #   true -> The products which belong to the entry are remembered in the
  #           globale "products"-hash instead of being stored in the db.
  #           This is used for initializing the database where we collect all
  #           products in one hash and store them afterwards instead of using
  #           Rails find_or_create_by_,,,
  #  false -> The products are stored with each product in the database.
  def self.save_entry entry, with_products_hash

    cvss_params = {}
    if entry.cvss
      cvss_params = cvss_hash(entry)
    end
    
    params = {
      :cve => entry.cve,
      :cwe => entry.cwe,
      :summary => entry.summary,
      :published => DateTime.xmlschema(entry.published_datetime),
      :last_modified => DateTime.xmlschema(entry.last_modified_datetime),
      :cvss => Cvss.create(cvss_params)
    }
    db_entry = NvdEntry.create(params)
    
    entry.vulnerable_software.each do |product|
      if with_products_hash # just remember it, we'll store it later.
        if @products.has_key? product.to_sym
          @products[product.to_sym] << entry.cve
        else
          @products[product.to_sym] = [ entry.cve ]
        end
      else
        save_product product, entry.cve
      end
    end
    
    create_references entry, db_entry.id
    
    db_entry.save!
  end
  
  # save_products does not check for product duplicates and should be used for
  # the DB-initialization. fix_product_duplicates should be called afterwards.
  def self.save_products
    puts "[*] I'm storing the products now (#{@products.size})"
    i = 0
    @products.each_pair do |product, cves|
      values = product.to_s.split(":")
      values[1].sub!("/", "")
      # values = [cpe, part, vendor, product, version, update, edition, language]
      p = Product.create({
            :part      => values[1],
            :vendor    => values[2],
            :product   => values[3],
            :version   => values[4],
            :update_nr => values[5],
            :edition   => values[6],
            :language  => values[7]
          })
      cves.each do |cve|
        # Save the relations between vulnerable software and nvd_entries
        VulnerableSoftware.find_or_create_by_nvd_entry_id_and_product_id(
          NvdEntry.find_by_cve(cve).id, p.id)
      end
      if i % 100 == 0
        puts "Stored 100 products [#{i}/#{@products.size}]"
      end
      i += 1
    end
    puts "[*] All products stored."
  end
  
  def self.save_product product, cve
    values = product.to_s.split(":")
    values[1].sub!("/", "")
    p = Product.find_or_create_by_part_and_vendor_and_product_and_version_and_update_nr_and_edition_and_language(
      values[1], values[2], values[3], values[4], values[5], values[6], values[7])
    VulnerableSoftware.find_or_create_by_product_id_and_nvd_entry_id(p.id, NvdEntry.find_by_cve(cve).id)
  end
  
  
  def self.fix_product_duplicates
    products = Product.all
    puts "[*] I'm checking #{products.size} products for duplicates."+
         "Building a hash with unique products..."
    cleaned_products = {}
    products.each do |p|
      product_name = ("#{p.part}:#{p.vendor}:#{p.product}:#{p.version}"+
          ":#{p.update_nr}:#{p.edition}:#{p.language}").to_sym
      
      # There is another product which has the same content, so we need to
      # change the vulnerable_software.product_id's
      if cleaned_products.has_key? product_name
        p.vulnerable_softwares.each do |vuln_s|
          vuln_s.product_id = cleaned_products[product_name]
          vuln_s.save!
        end
        
      # this is a newly found product so we remember its id
      else
        cleaned_products[product_name] = p.id
      end
    end
    puts "[*] Hash complete. I'll delete all non-unique products now..."
    # We now have a hash which has only unique products and destroy all other
    # products
    delete_count = 0
    products.each do |product|
      unless cleaned_products.has_value?(product.id)
        puts "Duplicate ID=#{product.id}"
        product.destroy
        delete_count += 1
      end
    end
    puts "[*] I've deleted #{delete_count} duplicates."
  end
  
  # saves the references for an cve entry in the database
  def self.create_references xml_entry, nvd_entry_id
      xml_entry.references.each do |ref|
        VulnerabilityReference.create({
          :name => ref.name,
          :link => ref.link,
          :source => ref.source,
          :nvd_entry_id => nvd_entry_id
        })

  # In contrast to save_entries_to_models this method checks already existent
  # CVE Entries. Therefore the former should be used to initialize the CVE-DB
  # and update_cves to store newly or updated CVE-Entries.
  def self.update_cves xml_entries
    i_new = 0
    i_updated = 0
    xml_entries.each do |xml_entry|
      
      entry_params = {
        :cwe           => xml_entry.cwe,
        :summary       => xml_entry.summary,
        :published     => xml_entry.published_datetime,
        :last_modified => xml_entry.last_modified_datetime
      }
      
      if nvd_entry = NvdEntry.find_by_cve(xml_entry.cve) # update entry
        nvd_entry.update_attributes(entry_params)
        
        
        xml_entry.vulnerable_software.each do |xml_product|
          values = xml_product.to_s.split(":")
          values[1].sub!("/", "")
          product = Product.find_or_initialize_by_part_and_vendor_and_product_and_version_and_update_nr_and_edition_and_language({
            :part => values[1],
            :vendor => values[2],
            :product => values[3],
            :version => values[4],
            :update_nr => values[5],
            :edition => values[6],
            :language => values[7]
          })
          if product.new_record?
            nvd_entry.vulnerable_configurations << product
            product.save!
          end
          
          nvd_entry.references.destroy
          create_references xml_entry, nvd_entry.id
          
          if nvd_entry.cvss
            nvd_entry.update_attributes(cvss_hash xml_entry)
          else
            nvd_entry.cvss = Cvss.create(cvss_hash xml_entry)
          end
        end
        nvd_entry.save!
        i_updated += 1
      else
        save_entry xml_entry, false
        i_new += 1
      end
    end
  end
  
  def self.cvss_hash entry
    cvss_params = {
        :score => entry.cvss.score,
        :source => entry.cvss.source,
        :generated_on => DateTime.xmlschema(entry.cvss.generated_on_datetime),
        :access_vector => entry.cvss.access_vector,
        :access_complexity => entry.cvss.access_complexity,
        :authentication => entry.cvss.authentication,
        :confidentiality_impact => ConfidentialityImpact.create({ :impact_id => Impact.find_by_name(entry.cvss.confidentiality_impact).id}),
        :integrity_impact => IntegrityImpact.create({ :impact_id => Impact.find_by_name(entry.cvss.integrity_impact).id }),
        :availability_impact => AvailabilityImpact.create({ :impact_id => Impact.find_by_name(entry.cvss.availability_impact).id })
    }
  end
end
