class NvdEntry < ActiveRecord::Base
  
  belongs_to :cvss
  
  has_many :vulnerable_softwares
  has_many :vulnerable_configurations
  has_many :references
  
end
