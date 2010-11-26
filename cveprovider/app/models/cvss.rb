class Cvss < ActiveRecord::Base
  has_one :confidentiality_impact
  has_one :availability_impact
  has_one :integrity_impact
end
