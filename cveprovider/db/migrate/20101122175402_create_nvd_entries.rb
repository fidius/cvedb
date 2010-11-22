class CreateNvdEntries < ActiveRecord::Migration
  def self.up
    create_table :nvd_entries do |t|
      t.string :cve
      t.string :cwe
      t.integer :cvss_id
      t.string :summary
      t.datetime :published
      t.datetime :last_modified

      t.timestamps
    end
  end

  def self.down
    drop_table :nvd_entries
  end
end
