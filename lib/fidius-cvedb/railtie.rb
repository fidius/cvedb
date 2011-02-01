require 'fidius-cvedb'
require 'rails'


GEM_BASE = File.join(ENV['GEM_PATH'], 'fidius-cvedb', 'lib')

module Fidius
  module Cvedb
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/parse_cves.rake"
        load "tasks/db_backup.rake"
      end
       
      # configure our plugin on boot. other extension points such
      # as configuration, rake tasks, etc, are also available
      initializer "fidius_cvedb.initialize" do |app|
        app.config.autoload_path += File.join(GEM_BASE, 'models', 'fidius', 'cve_db')
      end 
      
      #$LOAD_PATH << File.join(GEM_BASE, 'models', 'fidius', 'cve_db')
    end
  end
end
