# TODO Überprüfen ob die XML das richtige Format/Version 2.x hat.

# Benoetigt Ruby Version >= 1.9, ansonsten gibt es einen Fehler in der cvss
# Methode ("odd number list for Hash").

module NVDParser

  require 'nokogiri'
  
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
  
  
  class Cvss
    
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
  
  
  def self.parse_nvd_file file
    
    begin
      doc = Nokogiri::XML(File.open(file))
    
      entries = []
    
      doc.css('nvd > entry').each do |entry|
        entries << single_entry(entry)     
      end
      entries
    rescue Errno::ENOENT => e
      puts "Error: #{e.message}"
    end
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
    
    cvss_params = {}
    {
      score:                  'score',
      source:                 'source',
      access_vector:          'access-vector',
      authentication:         'authentication',
      access_complexity:      'access-complexity',
      confidentiality_impact: 'confidentiality_impact',
      integrity_impact:       'integrity_impact',
      availability_impact:    'availability_impact',
      generated_on_datetime:  'generated_on_datetime'
    
    }.each_pair do |hash_key, xml_name|
      elem = metrics.at_css("cvss|#{xml_name}")
      value = elem ? elem.children.to_s : nil
      cvss_params[hash_key] = value
    end
    Cvss.new(cvss_params)
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

NVDParser::print_entries('nvdcve-2.0-recent.xml')
