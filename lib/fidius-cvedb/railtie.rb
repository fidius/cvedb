require 'fidius-cvedb'
require 'rails'

module Fidius
  module Cvedb
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/parse_cves.rake"
        load "tasks/db_backup.rake"
      end
    end
  end
end
