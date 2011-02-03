class Fidius::CveDb::VulnerableSoftware < Fidius::CveDb::CveConnection
  
  belongs_to :nvd_entry
  belongs_to :product
  
end
