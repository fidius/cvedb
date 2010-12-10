class CreateMscves < ActiveRecord::Migration
  def self.up
    create_table :mscves do |t|
      t.integer :nvd_entry_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :mscves
  end
end
