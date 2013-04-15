class FIDIUS::CveDb::Cvss < FIDIUS::CveDb::CveConnection
  attr_accessible :score, :source, :generated_on, :access_vector, :access_complexity, :authentication,
    :confidentiality_impact_id, :integrity_impact_id, :availability_impact_id
  has_one :confidentiality_impact
  has_one :availability_impact
  has_one :integrity_impact
end
