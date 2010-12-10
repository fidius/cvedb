class NvdEntry < ActiveRecord::Base
  
  has_one :cvss
  
  has_many :vulnerable_softwares
  has_many :vulnerable_configurations
  has_many :references

  validates_uniqueness_of :cve
  
end
