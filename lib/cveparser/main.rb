require "#{FIDIUS::CveDb::GEM_BASE}/cveparser/parser"
require "#{FIDIUS::CveDb::GEM_BASE}/cveparser/rails_store"
require "#{FIDIUS::CveDb::GEM_BASE}/cveparser/ms_parser"

include FIDIUS::CveDb

PARAMS = {
  '-p' => 'Parse new XML file passed as 2nd param.',
  '-f' => 'Fix duplicate products.',
  '-u' => 'Updates CVE-Entries, needs modified.xml or recent.xml by nvd.org as 2nd argument.',
  '-m' => 'Creates the mapping between CVEs and Microsoft Security Bulletin Notation entries in the database.'
}

case ARGV[0]
  when '-p' 
    entries = FIDIUS::NVDParser.parse_cve_file ARGV[1]  
    RailsStore.create_new_entries(ARGV[1].split("/").last, entries)
  when '-f'
    RailsStore.fix_product_duplicates
  when '-u'
    entries = FIDIUS::NVDParser.parse_cve_file ARGV[1]
    RailsStore.update_cves(entries)
  when '-m'
    FIDIUS::MSParser.parse_ms_cve
  else
    puts "ERROR: You've passed none or an unknown parameter, available "+
      "parameters are:"
    PARAMS.each_key do |param|
      puts "#{param}\t#{PARAMS[param]}"
    end
end
