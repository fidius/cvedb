class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table :references do |t|
      t.string :source
      t.string :link
      t.string :name
      t.integer :nvd_entry_id

      t.timestamps
    end
  end

  def self.down
    drop_table :references
  end
end
