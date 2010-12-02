# rake nvd:parse FILE=

require 'open-uri'
require 'net/http'

BASE_URL = "http://static.nvd.nist.gov/feeds/xml/cve/"
XML_DIR = "cveparser/xml/"
RECENT_XML = "nvdcve-2.0-recent.xml"

namespace :nvd do 
  desc 'Parses local XML-File.'
  task :parse, :file_name do |t,args|
    parse "#{XML_DIR + args[:file_name]}"
  end

  desc 'Downloads XML-File from NVD. (with names from nvd:list_remote)'
  task :get, :xml_name do |t,args|
    if args[:xml_name]
      wget args[:xml_name]
    else
      puts "Please call task with 'rake nvd:get[xml_name]'!"
    end 
  end
  
  desc 'Lists the locally available NVD-XML-Datafeeds.'
  task :list_local do
    if Dir.exists?(XML_DIR)
      dir = Dir.new XML_DIR
      dir.each do |entry|
        puts entry if entry =~ /.+\.xml$/
      end
    end
  end  

  desc 'Lists theremotely available NVD-XML-Datafeeds.'
  task :list_remote do
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

  # TODO update vervollständigen
  desc "Downloads the recent.xml from nvd.org and stores it's content in the db"
  task :update do
    sh "wget -P#{XML_DIR} #{BASE_URL + RECENT_XML}"
  end
end

def parse file
  if Rails.version[0].to_i < 3
    sh "ruby script/runner #{Rails.root.to_s}/cveparser/parser.rb #{file}"
  else
    sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb #{file}"
  end
end

def wget file
  FileUtils.mkdir_p(XML_DIR)
  sh "wget -P#{XML_DIR} #{BASE_URL + file}"
end