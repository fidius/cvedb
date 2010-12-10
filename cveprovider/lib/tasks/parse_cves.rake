require 'open-uri'
require 'net/http'

BASE_URL = "http://static.nvd.nist.gov/feeds/xml/cve/"
DOWNLOAD_URL = "http://nvd.nist.gov/download.cfm"
XML_DIR = "cveparser/xml/"
ANNUALLY_XML = /nvdcve-2[.]0-\d{4}[.]xml/

# modified xml includes all recent published and modified cve entries
MODIFIED_XML = "nvdcve-2.0-modified.xml"

namespace :nvd do 
  desc 'Parses local XML-File.'
  task :parse, :file_name do |t,args|
    parse args[:file_name]
  end
  

  # TODO: Prüfen ob die Dateien identisch sind (Größe + Hash)
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
      puts "No suitable XMLs are found."
    end
  end

  #TODO: prüfen, ob update auch in parser.rb geht
  desc "Downloads the modified.xml from nvd.org and stores it's content in the database."
  task :update do
    wget MODIFIED_XML
    parse MODIFIED_XML
  end

  desc("Initialisieren der CVE-DB, dabei werden alle Jahres-XMLs geparsed und "+
    "im Anschluss Produkte auf Duplikate geprueft und diese beseitigt.")
  task :initialize do
    init
  end
end

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
  local_x.each do |xml|
    l_ann_xmls << xml if xml.match ANNUALLY_XML
  end
  puts "[*] I've found #{l_ann_xmls.size} annually XML files locally. I'll "+
    "download the missing XMLs now."
  r_ann_xmls.each do |xml|
    wget xml unless l_ann_xmls.include? xml
    puts "Downloaded #{xml}."
  end
  puts "[*] All available files downloaded, parsing the XMLs now."
  l_ann_xmls.each do |xml|
    parse xml
  end
  puts "[*] All local XMLs parsed."
  fix_duplicates
  puts "[*] Initializing done."
end

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
  doc = Nokogiri::HTML(open(DOWNLOAD_URL))
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

def fix_duplicates
  if Rails.version[0].to_i < 3
    sh "ruby script/runner #{Rails.root.to_s}/cveparser/parser.rb -f"
  else
    sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb -f"
  end
end

def parse file
  if Rails.version[0].to_i < 3
    sh "ruby script/runner #{Rails.root.to_s}/cveparser/parser.rb -p #{XML_DIR + file}"
  else
    sh "rails runner #{Rails.root.to_s}/cveparser/parser.rb -p #{XML_DIR + file}"
  end
end

def wget file
  FileUtils.mkdir_p(XML_DIR)
  sh "wget -O#{XML_DIR + file} #{BASE_URL + file}"
end
