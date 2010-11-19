require 'roxml'

class SoftwareList
  include ROXML

  xml_accessor :vuln_product, :as => []

end

class CVSS
  include ROXML

  xml_accessor :score, :as => Float
  xml_accessor :access_vector, :from => 'access-vector'
  xml_accessor :access_complexity, :from => 'access-complexity'
  xml_accessor :authentication
  xml_accessor :integrity_impact, :from => 'integrity-impact'
  xml_accessor :availability_impact, :from => 'availability-impact'
  xml_accessor :confidentiality_impact, :from => 'confidentiality-impact'
  xml_accessor :source
end

class References
  include ROXML
  
  xml_accessor :reference
  xml_accessor :reference_link, :from => "@href"
  xml_accessor :source

  def to_s
    " reference=#{reference}\n link=#{reference_link}\n source=#{source}"
  end
  
end

class NVD_Entry
  include ROXML

  xml_accessor :nvd_id, :from => "@id"
  xml_accessor :cwe_id, :from => "cwe/@id"
  xml_accessor :vulnerable_software_list,  :as => SoftwareList, :from => 'vulnerable-software-list'
  xml_accessor :cvss,  :as => CVSS, :from => 'cvss/base_metrics'
  xml_accessor :published_datetime, :from => "published-datetime"
  xml_accessor :last_modified_datetime, :from => "last-modified-datetime"
  xml_accessor :references, :as => [References]
  xml_accessor :security_protection
  xml_accessor :summary
  
  def to_s
    puts "NVD_Entry attributes:\n nvd_id=#{nvd_id}\n cwe_id=#{cwe_id}\n"
    references.each do |reference|
      puts reference
    end
  end
end

class EntryList
  
end

def from_xml(parse_string)
  entry = NVD_Entry.from_xml(parse_string)
end

e = from_xml(File.read("einer.xml"))
puts e

