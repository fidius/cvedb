require 'fidius-cvedb'
require 'rails'
require 'fidius-cvedb/version'

module Fidius
  module CveDb
    GEM_BASE = File.join(ENV['GEM_HOME'], 'gems', "fidius-cvedb-#{VERSION}", 'lib')
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/parse_cves.rake"
        load "tasks/db_backup.rake"
        load "tasks/nvd_migrate.rake"
      end       
       Dir.glob(File.join GEM_BASE, 'models', 'fidius', 'cve_db', '*.rb') do |rb|
        require rb
       end
    end
  end
end
