class CreateAvailabilityImpacts < ActiveRecord::Migration
  def self.up
    create_table :availability_impacts do |t|
      t.integer :impact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :availability_impacts
  end
end
