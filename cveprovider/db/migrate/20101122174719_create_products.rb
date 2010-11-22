class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :part
      t.string :vendor
      t.string :product
      t.string :version
      t.string :update
      t.string :edition
      t.string :language

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
