module NVDParserModel

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

end
