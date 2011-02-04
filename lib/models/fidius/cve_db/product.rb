class FIDIUS::CveDb::Product < FIDIUS::CveDb::CveConnection
  
  has_many :vulnerable_softwares
  has_many :nvd_entries, :through => :vulnerable_softwares
  
end
