class CreateConfidentialityImpacts < ActiveRecord::Migration
  def self.up
    create_table :confidentiality_impacts do |t|
      t.integer :impact_id
      t.integer :cvss_id
      t.timestamps
    end
  end

  def self.down
    drop_table :confidentiality_impacts
  end
end
