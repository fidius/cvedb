# rake nvd:parse FILE=

require 'open-uri'

BASE_URL = "http://static.nvd.nist.gov/feeds/xml/cve/"

namespace :nvd do 
  desc 'Parses local XML-File.'
  task :parse_file do
    if Rails.version[0].to_i < 3
      sh "ruby script/runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
    else
      sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb #{ENV['FILE']}"
    end
  end

  desc 'Lists the available NVD-XML-Datafeeds.'
  task :list do
    doc = Nokogiri::HTML(open("http://nvd.nist.gov/download.cfm"))
    links = doc.css("div.rightbar > a")
    xmls = []
    links.each do |link|
      link_name = link.attributes['href'].to_s
      if link_name
        xmls << link_name.split("/").last if link_name.include? BASE_URL    
      end    
    end
    puts "#{xmls.size} XMLs available:\n------"
    puts xmls
  end
end
