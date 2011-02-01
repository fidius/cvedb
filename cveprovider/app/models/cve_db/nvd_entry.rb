class CveDb::NvdEntry < CveDb::CveConnection
  
  has_one :cvss
  has_one :mscve
  
  has_many :vulnerable_softwares
  has_many :vulnerable_configurations
  has_many :vulnerability_references

  validates_uniqueness_of :cve
  
  def references_string
    res = ""
    vulnerability_references.each_with_index do |reference, i|
      # http://www.foo-bar.de/sub/sub-sub -> www.foo-bar.de
      link_name = reference.link.scan(/(?:https?|s?ftp):\/\/([^\/]+)/).to_s
      res += "<a href=\"#{reference.link}\">#{link_name}</a>"
      res += " | " unless i == vulnerability_references.size-1
    end
    res
  end
  
end
