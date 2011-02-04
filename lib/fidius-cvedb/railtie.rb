require 'fidius-cvedb'
require 'rails'

module FIDIUS
  module CveDb
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/parse_cves.rake"
        load "tasks/db_backup.rake"
        load "tasks/nvd_migrate.rake"
      end       
    end
  end
end
