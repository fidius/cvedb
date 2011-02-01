class CveDb::VulnerableSoftware < CveDb::CveConnection
  
  belongs_to :nvd_entry
  belongs_to :product
  
end
