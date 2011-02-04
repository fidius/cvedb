class FIDIUS::CveDb::CveConnection < ActiveRecord::Base
  # If the application is using the cve_db as foreign database this should be
  # uncommented.
  database_yml = YAML.load_file(File.join RAILS_ROOT, 'config', 'database.yml')
  establish_connection database_yml['cve_db']
  
  self.abstract_class = true
end
