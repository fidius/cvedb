require 'open-uri'

module MSParser

  def self.parse_ms_cve
    entries = parse
    counter = 0
    entries.each_pair do |ms,cves|
      cves.each do |cve|        
        existing_cve = NvdEntry.find_by_cve(cve)
        if existing_cve
          Mscve.find_or_create_by_nvd_entry_id_and_name(existing_cve.id, ms)
          puts "Found: #{existing_cve.cve}."
          counter += 1
        end
      end
    end  
    puts "Added #{counter} items to database."
  end

  def self.print_map
    entries = parse    
    entries.each_pair do |ms,cves|
      puts "#{ms}"
      cves.each {|cve| puts "----#{cve}"}
    end
  end 

  private

  def self.parse
    doc = Nokogiri::HTML(open("http://cve.mitre.org/data/refs/refmap/source-MS.html"))
    entries = Hash.new("")
    current_ms_entry = ""
    doc.css('table[border="2"] > tr').each do |entry|
      entry.css("td").each do |td|
        if td.content =~ /CVE-\d{4}-\d{4}/
          entries[current_ms_entry] = td.content.split("\n")
        else
          current_ms_entry = td.content.split(":").last
          entries[current_ms_entry]
        end
      end
    end
    puts "Parsed #{entries.size} entries."
    entries
  end
end

MSParser.parse_ms_cve
