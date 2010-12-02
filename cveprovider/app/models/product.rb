class Product < ActiveRecord::Base
  
  has_many :vulnerable_softwares
  
end
