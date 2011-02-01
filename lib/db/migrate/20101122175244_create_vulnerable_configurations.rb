class CreateVulnerableConfigurations < ActiveRecord::Migration
  def self.up
    create_table :vulnerable_configurations do |t|
      t.integer :nvd_entry_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vulnerable_configurations
  end
end
