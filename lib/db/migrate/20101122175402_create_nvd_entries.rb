class CreateNvdEntries < ActiveRecord::Migration
  def self.up
    create_table :nvd_entries do |t|
      t.string :cve
      t.string :cwe
      t.string :summary
      t.datetime :published
      t.datetime :last_modified

      t.timestamps
    end
    add_index :nvd_entries, :cve
  end

  def self.down
    drop_table :nvd_entries
  end
end
