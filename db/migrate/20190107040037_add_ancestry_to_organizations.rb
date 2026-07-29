class AddAncestryToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :ancestry, :string
    add_index :organizations, :ancestry
  end
end
