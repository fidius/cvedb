class Fidius::CveDb::CveConnection < ActiveRecord::Base
  # If the application is using the cve_db as foreign database this should be
  # uncommented.
  #establish_connection :cve_db
  
  self.abstract_class = true
end
