class FIDIUS::CveDb::VulnerableSoftware < FIDIUS::CveDb::CveConnection
  attr_accessible :nvd_entry_id, :product_id
  belongs_to :nvd_entry
  belongs_to :product
  
end
