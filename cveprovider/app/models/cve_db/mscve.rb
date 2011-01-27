class CveDb::Mscve < CveDb::CveConnection
  belongs_to :nvd_entry
end
