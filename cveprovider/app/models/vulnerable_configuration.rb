class VulnerableConfiguration < ActiveRecord::Base
  
  belongs_to :nvd_entry
  belongs_to :product
  
end
