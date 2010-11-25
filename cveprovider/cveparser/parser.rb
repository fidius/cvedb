# TODO Überprüfen ob die XML das richtige Format/Version 2.x hat.

# Benoetigt Ruby Version >= 1.9, ansonsten gibt es einen Fehler in der cvss
# Methode ("odd number list for Hash").

module NVDParser
  
  class NVDEntry
    
    attr_accessor :cve, :vulnerable_configurations, :cvss, :vulnerable_software,
        :published_datetime, :last_modified_datetime, :cwe, :summary,
        :references
    
    def initialize(params)
      @vulnerable_configurations = params[:vulnerable_configurations]
      @vulnerable_software       = params[:vulnerable_software]
      @published_datetime        = params[:published_datetime]
      @last_modified_datetime    = params[:last_modified_datetime]
      @cvss       = params[:cvss]
      @cve        = params[:cve]
      @cwe        = params[:cwe]
      @summary    = params[:summary]
      @references = params[:references]
    end
    
    def to_s
      puts "NVDEntry\n CVE-Nr\t: #{cve}\n CVSS\t: #{cvss.score}\n"+
          " CWE\t: #{cwe}"
    end
    
  end
  
  
  class Reference
    
    attr_accessor :source, :link, :name
    
    def initialize(params)
      @source = params[:source]
      @link   = params[:link]
      @name   = params[:name]
    end
    
    def to_s
      "source=#{source}, link=#{link}, name=#{name}"
    end
    
  end
  
  
  class Cvss_
    
    attr_accessor :score, :access_vector, :access_complexity, :authentication,
        :confidentiality_impact, :integrity_impact, :availability_impact,
        :source, :generated_on_datetime
    
    def initialize(params)
      @source         = params[:source]
      @score          = params[:score]
      @access_vector  = params[:access_vector]
      @authentication = params[:authentication]
      @access_complexity      = params[:access_complexity]
      @integrity_impact       = params[:integrity_impact]
      @availability_impact    = params[:availability_impact]
      @confidentiality_impact = params[:confidentiality_impact]
      @generated_on_datetime  = params[:generated_on_datetime]
    end
    
  end
  
  def self.save_entries_to_models file
    
    entries = parse_nvd_file file
    num_entries = entries.size
    puts "Finished parsing: Found #{num_entries} entries"   
    i = 1
    thread_count = 0
    entries.each do |entry|
      puts "START: #{entry.cve} [#{i}/#{num_entries}]"
      i += 1
      
      save_entry(entry)
    end
  end
  
  def self.save_entry entry

    #Create NVD-Entry and attributes
    db_entry = NvdEntry.find_or_create_by_cve(entry.cve)
    db_entry.update_attributes({
      :cve => entry.cve,
      :cwe => entry.cwe,
      :summary => entry.summary,
      :published => DateTime.xmlschema(entry.published_datetime),
      :last_modified => DateTime.xmlschema(entry.last_modified_datetime)
    })
    if entry.cvss
      #Create CVSS Entry
      time = entry.cvss.generated_on_datetime ? DateTime.xmlschema(entry.cvss.generated_on_datetime) : nil
      cvss_params = {
        :score => entry.cvss.score,
        :source => entry.cvss.source,
        :generated_on => time,
        :access_vector => entry.cvss.access_vector,
        :access_complexity => entry.cvss.access_complexity,
        :authentication => entry.cvss.authentication
      }

      integrity_params = {
        :impact_id => Impact.find_by_name(entry.cvss.integrity_impact).id
      }

      confidentiality_params = {
        :impact_id => Impact.find_by_name(entry.cvss.confidentiality_impact).id
      }
      
      availability_params = {
        :impact_id => Impact.find_by_name(entry.cvss.availability_impact).id
      }

      unless db_entry.cvss
        db_entry.cvss = Cvss.create(cvss_params)
        c_impact = ConfidentialityImpact.create(confidentiality_params)
        i_impact = IntegrityImpact.create(integrity_params)
        a_impact = AvailabilityImpact.create(availability_params)
        db_entry.cvss.confidentiality_impact = c_impact
        db_entry.cvss.integrity_impact = i_impact
        db_entry.cvss.availability_impact = a_impact
        db_entry.cvss.save!
      else
        db_entry.cvss.update_attributes(cvss_params)
        db_entry.cvss.confidentiality_impact.update_attributes(confidentiality_params)
        db_entry.cvss.integrity_impact.update_attributes(integrity_params)
        db_entry.cvss.availability_impact.update_attributes(availability_params)
      end
    end
    
    entry.vulnerable_configurations.each do |product|
      values = product.split(":")
      values[1].sub!("/", "")
      # values = [cpe, part, vendor, product, version, update, edition, language]
      p = Product.find_or_create_by_part_and_vendor_and_product_and_version_and_update_nr_and_edition_and_language(
        values[1], values[2], values[3], values[4], values[5], values[6], values[7])
      VulnerableConfiguration.find_or_create_by_nvd_entry_id_and_product_id(db_entry.id, p.id)
    end
    
    entry.vulnerable_software.each do |product|
      values = product.split(":")
      values[1].sub!("/", "")
      # values = [cpe, part, vendor, product, version, update, edition, language]
      p = Product.find_or_create_by_part_and_vendor_and_product_and_version_and_update_nr_and_edition_and_language(
        values[1], values[2], values[3], values[4], values[5], values[6], values[7])
      VulnerableSoftware.find_or_create_by_nvd_entry_id_and_product_id(db_entry.id, p.id)
    end

    entry.references.each do |ref|
      r = VulnerabilityReference.find_or_create_by_name_and_link_and_source_and_nvd_entry_id(ref.name, 
                                                                                ref.link, ref.source, db_entry.id)        
    end
    
    db_entry.save!
  end
  
  def self.parse_nvd_file file

    doc = Nokogiri::XML(File.open(file))
  
    entries = []
  
    doc.css('nvd > entry').each do |entry|
      entries << single_entry(entry)     
    end
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
      
    NVDEntry.new(params)
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
      ref_array << Reference.new(ref_params)
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
      Cvss_.new(cvss_params)
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

NVDParser::save_entries_to_models('cveparser/nvdcve-2.0-2010.xml')
