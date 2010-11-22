class CreateCvsses < ActiveRecord::Migration
  def self.up
    create_table :cvsses do |t|
      t.float :score
      t.string :source
      t.datetime :generated_on
      t.string :access_vector
      t.string :access_complexity
      t.string :authentication
      t.integer :integrity_impact_id
      t.integer :confidentiality_impact_id
      t.integer :availability_impact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cvsses
  end
end
