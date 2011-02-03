class Fidius::CveDb::VulnerableConfiguration < Fidius::CveDb::CveConnection
  
  belongs_to :nvd_entry
  belongs_to :product
  
end
