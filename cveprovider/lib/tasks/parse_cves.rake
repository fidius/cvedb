# rake nvd:parse FILE=

require 'open-uri'

namespace :nvd do 
  desc 'Parse all xml files which are passed.'
  task :parse do
    if Rails.version[0].to_i < 3
      sh "ruby script/runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
    else
      sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
    end
  end

  task :list do
    doc = Nokogiri::HTML(open("http://nvd.nist.gov/download.cfm"))
    links = doc.css("div.rightbar > a")
    xmls = []
    links.each do |link|
      link_name = link.attributes['href']
      xmls << link_name if link_name.contains? "http://static.nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-"
    end
  end
end
