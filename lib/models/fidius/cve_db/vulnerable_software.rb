class FIDIUS::CveDb::VulnerableSoftware < FIDIUS::CveDb::CveConnection
  
  belongs_to :nvd_entry
  belongs_to :product
  
end
