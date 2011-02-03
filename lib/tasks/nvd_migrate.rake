require 'yaml'

namespace :nvd do 
  desc 'Execute NVD migrations'
  task :migrate do
    db_connect
    ActiveRecord::Migrator.migrate(File.join Fidius::CveDb::GEM_BASE, 'db', 'migrate')
  end
  
  desc "Drop NVD database"
  task :drop do
    db_connect
    #TODO: Drop database
    
  end
end

def db_connect
  db_config = YAML.load_file(File.join(Rails.root.to_s, 'config', 'database.yml'))
    if db_config["cve_db"]
      ActiveRecord::Base::establish_connection db_config["cve_db"]
    else
      puts "No configuration found for cve_db in config/database.yml!"
    end
end
