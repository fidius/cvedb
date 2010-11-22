class CreateImpacts < ActiveRecord::Migration
  def self.up
    create_table :impacts do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :impacts
  end
end
