class CreateDefaultImpacts < ActiveRecord::Migration
  
  IMPACT_DEFAULTS = %w[NONE PARTIAL COMPLETE]
  
  def self.up
    IMPACT_DEFAULTS.each do |name|
      CveDb::Impact.find_or_create_by_name(name)
    end
  end

  def self.down
    IMPACT_DEFAULTS.each do |name|
      impacts = Impact.where({ :name => name })
      impacts.each do |impact|
        impact.destroy!
      end
    end
  end
end
