class ChangeImpactsStructure < ActiveRecord::Migration
  def self.up
    add_column :cvsses, :availability_impact_id, :integer
    add_column :cvsses, :confidentiality_impact_id, :integer
    add_column :cvsses, :integrity_impact_id, :integer
  end

  def self.down
    remove_column :cvsses, :availability_impact_id
    remove_column :cvsses, :confidentiality_impact_id
    remove_column :cvsses, :integrity_impact_id
  end
end
