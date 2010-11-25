class Cvss < ActiveRecord::Base
  belongs_to :confidentiality_impact
  belongs_to :availability_impact
  belongs_to :integrity_impact
end
