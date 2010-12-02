# TODO Überprüfen ob die XML das richtige Format/Version 2.x hat.

# Benoetigt Ruby Version >= 1.9, ansonsten gibt es einen Fehler in der cvss
# Methode ("odd number list for Hash").
require "#{Rails.root.to_s}/cveparser/parser_model"

module NVDParser
  
  include NVDParserModel
  
  MAX_THREADS  = 4
  MODIFIED_XML = "nvdcve-2.0-modified.xml"
  # We teporarily store the vuln products in a hash to fix duplicates easily.
  # The hash looks like this: { :"vulnerable_software_string" => [ cves ] }
  $products = {}
  
  def self.save_entries_to_models file
    
    xml_file = file.split("/").last
    xml_db_entry = Xml.find_by_name(xml_file)

    if xml_db_entry and xml_file != MODIFIED_XML
      puts "\n#{xml_file} is already in the database! Please use 'rake nvd:update' to fetch the most recent updates."
      return
    end    
    entries = parse_nvd_file file
    
    start_time = Time.now
    puts "[*] Storing the CVE-Entries in DB"
    
    num_entries = entries.size
    i = 1
    thread_count = 0
    if thread_count <= MAX_THREADS
      thread_count += 1
      Thread.new do
      save_entry(entry)
      thread_count -= 1
      end
    end
    
    entries.each do |entry|
      puts "Store: #{entry.cve} [#{i}/#{num_entries}]"
      i += 1
      
      save_entry(entry)
    end
    # Until now, the products are only remembered in the $products hash, they
    # are saved when all products are collected so we dont have duplicates
    save_products
    
    params = {:name => xml_file, :create_time => Time.now.to_datetime}
    
    if xml_db_entry
      xml_db_entry.update_attributes(params[:create_time])
    else
      Xml.create(params)      
    end

    total_time = (Time.now - start_time).round
    puts "[*] All Entries & Products stored, this has taken "+
        "#{total_time/60}:#{total_time%60}"
  end
  
  def self.save_entry entry

    #Create NVD-Entry and attributes
    
    cvss_params = {}
    if entry.cvss
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
      
      if $products.has_key? product.to_sym
        $products[product.to_sym] << entry.cve
      else
        $products[product.to_sym] = [ entry.cve ]
      end
      
      #values = product.split(":")
      #values[1].sub!("/", "")
      ## values = [cpe, part, vendor, product, version, update, edition, language]
      #p = Product.create({
      #      :part => values[1],
      #      :vendor => values[2],
      #      :product => values[3],
      #      :version => values[4],
      #      :update_nr => values[5],
      #      :edition => values[6],
      #      :language => values[7],
      #    })
      #VulnerableSoftware.find_or_create_by_nvd_entry_id_and_product_id(db_entry.id, p.id)
    end
    
    entry.references.each do |ref|
      VulnerabilityReference.create({
        :name => ref.name,
        :link => ref.link,
        :source => ref.source,
        :nvd_entry_id => db_entry.id
      })
    end
    
    db_entry.save!
  end
  
  
  def self.save_products
    puts "[*] I'm storing the products now (#{$products.size})"
    i = 0
    $products.each_pair do |product, cves|
      values = product.to_s.split(":")
      values[1].sub!("/", "")
      # values = [cpe, part, vendor, product, version, update, edition, language]
      p = Product.create({
            :part => values[1],
            :vendor => values[2],
            :product => values[3],
            :version => values[4],
            :update_nr => values[5],
            :edition => values[6],
            :language => values[7]
          })
      cves.each do |cve|
        # Save the relations between vulnerable software and nvd_entries
        VulnerableSoftware.find_or_create_by_nvd_entry_id_and_product_id(
          NvdEntry.find_by_cve(cve).id, p.id)
      end
      if i % 100 == 0
        puts "Stored 100 products [#{i}/#{$products.size}]"
      end
      i += 1
    end
    puts "[*] All products stored."
  end
  
  
  def self.parse_nvd_file file
    start_time = Time.now
    puts "[*] Start parsing \"#{file}\""
    doc = Nokogiri::XML(File.open(file))
  
    entries = []
    entry_count = 0
    doc.css('nvd > entry').each do |entry|
      entries << single_entry(entry)
      entry_count += 1
      if entry_count % 100 == 0
        puts "I've parsed #{entry_count} CVE Entries"
      end
    end
    end_time = Time.now
    puts "[*] Finished parsing, I've found #{entries.size} entries. "+
        "Parsing time is #{(end_time-start_time).round} seconds."
    entries
  end
  
  
  def self.single_entry entry
    params = {}
    params[:cve] = entry.attributes['id'].value
    params[:vulnerable_configurations] = vulnerable_configurations(entry)
    params[:cvss] = cvss(entry)
    params[:vulnerable_software] = vulnerable_software(entry)
    params[:published_datetime] = child_value(entry, 'vuln|published-datetime')
    params[:last_modified_datetime] = child_value(entry, 'vuln|last-modified-datetime')
    params[:cwe] = cwe(entry)
    params[:summary] = child_value(entry, 'vuln|summary')
    params[:references] = references(entry)
      
    NVDParserModel::NVDEntry.new(params)
  end
  
  
  def self.cwe entry
    cwe = entry.at_css('vuln|cwe')
    cwe.attributes['id'].value if cwe
  end
  
  
  def self.references entry
    ref_array = []
    entry.css('vuln|references').each do |references|
      ref_params = {}
      ref_params[:source] = child_value(references, 'vuln|source')
      ref_params[:link] = references.at_css('vuln|reference').attributes['href'].value
      ref_params[:name] = child_value(references, 'vuln|reference')
      ref_array << NVDParserModel::Reference.new(ref_params)
    end
    ref_array
  end
    
  
  def self.vulnerable_software entry
    vuln_products = []
    entry.css('vuln|vulnerable-software-list > vuln|product').each do |product|
      vuln_products << product.children.to_s if product
    end
    vuln_products
  end
  
  
  def self.cvss entry
    
    metrics = entry.css('vuln|cvss > cvss|base_metrics')
    unless metrics.empty?
      cvss_params = {}
      {
        score:                  'score',
        source:                 'source',
        access_vector:          'access-vector',
        authentication:         'authentication',
        access_complexity:      'access-complexity',
        confidentiality_impact: 'confidentiality-impact',
        integrity_impact:       'integrity-impact',
        availability_impact:    'availability-impact',
        generated_on_datetime:  'generated-on-datetime'
      
      }.each_pair do |hash_key, xml_name|
        elem = metrics.at_css("cvss|#{xml_name}")
        value = elem ? elem.children.to_s : nil
        cvss_params[hash_key] = value
      end
      NVDParserModel::Cvss_.new(cvss_params)
    end
  end
  
  
  def self.vulnerable_configurations entry
    v_confs = []
    entry.css('vuln|vulnerable-configuration > cpe-lang|logical-test'+
                    ' > cpe-lang|fact-ref').each do |conf|
        v_confs << conf.attributes['name'].value
    end
    v_confs
  end
  
  
  def self.print_entries file
    entries = parse_nvd_file(file)
    puts "Entry count = #{entries.size}"
    entries.each do |entry|
      puts entry.to_s
    end
  end
  
  private
  
  def self.child_value(node, xml)
    val = node.at_css(xml)
    val.children.to_s if val
  end
  
end

NVDParser::save_entries_to_models(ARGV[0])
