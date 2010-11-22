class CreateIntegrityImpacts < ActiveRecord::Migration
  def self.up
    create_table :integrity_impacts do |t|
      t.integer :impact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :integrity_impacts
  end
end
