require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'fidius-cvedb'

BASE_URL = "http://static.nvd.nist.gov/feeds/xml/cve/"
BASE_SSL_URL = "https://nvd.nist.gov/static/feeds/xml/cve/"
DOWNLOAD_URL = "https://nvd.nist.gov/download.cfm"
#GEM_BASE = File.join(ENV['GEM_HOME'], 'gems', "fidius-cvedb-#{FIDIUS::CveDb::VERSION}", 'lib')
XML_DIR = File.join(Dir.pwd, "cveparser", "xml")
ANNUALLY_XML = /nvdcve-2[.]0-\d{4}[.]xml/

# modified xml includes all recent published and modified cve entries
MODIFIED_XML = "nvdcve-2.0-modified.xml"
RECENT_XML = "nvdcve-2.0-recent.xml"

namespace :nvd do 
  desc 'Parses local XML-File.'
  task :parse, :file_name do |t,args|
    cve_main '-p', args[:file_name]
  end
  
  desc 'Downloads XML-File from NVD. (with names from nvd:list_remote)'
  task :get, :xml_name do |t,args|
    if args[:xml_name]
      wget args[:xml_name]
    else
      puts "Please call task with 'rake nvd:get[<xml_name>]'!"
    end 
  end
  
  desc 'Lists the locally available NVD-XML-Datafeeds.'
  task :list_local do
    puts local_xmls
  end  

  desc 'Lists the remotely available NVD-XML-Datafeeds.'
  task :list_remote do
    xmls = remote_xmls
    if xmls
      puts "#{xmls.size} XMLs available:\n------"
      puts xmls
    else
      puts "No suitable XMLs found."
    end
  end

  desc "Downloads the modified.xml from nvd.org and stores it's content in the database."
  task :update do
    wget MODIFIED_XML
    cve_main '-u', MODIFIED_XML
    wget RECENT_XML
    cve_main '-u', RECENT_XML
  end

  desc "Initializes the CVE-DB, parses all annual CVE-XMLs and removes duplicates."
  task :initialize do
    init
  end

  desc "Creates the mapping between CVEs and Microsoft Security Bulletin Notation in the database."
  task :mscve do
    cve_main '-m'
  end
end

# ---------- Helper - Methods ---------- #

# Initializes the CVE-DB with all CVE data available in the NVD.
def init
  local_x = local_xmls
  if local_x
    puts "WARNING: The XML directory already contains XML files. "+
      "nvd:initialize is intended to be used only once to set up the "+
      "CVE-Entries. To update the CVE-Entries use nvd:update.\n\n"+
      "If you don't cancel the task I'll proceed in 20 seconds."
    sleep 20
  end
  puts "[*] Looking for XMLs at #{DOWNLOAD_URL}"
  remote_x = remote_xmls
  r_ann_xmls = []
  remote_x.each do |xml|
    r_ann_xmls << xml if xml.match ANNUALLY_XML
  end
  puts "[*] I've found #{r_ann_xmls.size} annually XML files remotely."
  puts "[*] Checking locally available XMLs."
  l_ann_xmls = []
  if local_x
    local_x.each do |xml|
      l_ann_xmls << xml if xml.match ANNUALLY_XML
    end
  end
  puts "[*] I've found #{l_ann_xmls.size} annually XML files locally. I'll "+
    "download the missing XMLs now."
  r_ann_xmls.each do |xml|
    puts "Downloading #{xml}."
    wget xml unless l_ann_xmls.include? xml
    puts "Downloaded #{xml}."
  end
  puts "[*] All available files downloaded, parsing the XMLs now."
  l_ann_xmls.each do |xml|
    cve_main '-p', xml
  end
  puts "[*] All local XMLs parsed."
  cve_main '-f'
  puts "[*] Initializing done."
end

# Returns an array of xmls that were previously downloaded
def local_xmls
  if Dir.exists?(XML_DIR)
    entries = []
    dir = Dir.new XML_DIR
    dir.each do |entry|
      entries << entry if entry =~ /.+\.xml$/
    end
    return (entries.empty? ? nil : entries)
  else
    puts "ERROR: There is no directory \"#{XML_DIR}\" where I can look for XMLs."
    return nil
  end
end

# Returns an array of available xmls or nil if none are found.
def remote_xmls
  doc = Nokogiri::HTML open(DOWNLOAD_URL)
  links = doc.css("div.rightbar > a")
  xmls = []
  links.each do |link|
    link_name = link.attributes['href'].to_s
    if link_name
      xmls << link_name.split("/").last if link_name.include? BASE_URL
    end    
  end
  xmls.empty? ? nil : xmls
end

# Calls the main.rb script with appropriate options
def cve_main option, file = ''
  runner_version = Rails.version[0].to_i < 3 ? "ruby script/runner" : "rails runner"
  main_script = "#{runner_version} #{File.join(FIDIUS::CveDb::GEM_BASE, "cveparser", "main.rb")}" 
  param = file.empty? ? file : " #{File.join(XML_DIR, file)}"
  puts "Working Dir : #{Dir.pwd}"
  sh "#{main_script} #{option} #{param}" 
end

# Simple wget 
def wget file
  FileUtils.mkdir_p(XML_DIR)
  #sh "curl -O #{File.join(XML_DIR, file)} #{BASE_URL + file}"
  response = open("#{BASE_SSL_URL + file}")
  open("#{File.join(XML_DIR, file)}", "wb") do |f|
    # read the file object
    f.write(response.read)
  end
end
