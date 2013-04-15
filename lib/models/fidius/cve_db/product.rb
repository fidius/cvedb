class FIDIUS::CveDb::Product < FIDIUS::CveDb::CveConnection
  attr_accessible :part, :vendor, :product, :version, :update_nr, :edition, :language
  has_many :vulnerable_softwares
  has_many :nvd_entries, :through => :vulnerable_softwares
  
end
