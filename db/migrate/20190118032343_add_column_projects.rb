class AddColumnProjects < ActiveRecord::Migration
  def change
    add_column :projects, :purchase, :string
    add_column :projects, :purchase_phone, :string
    add_column :projects, :design, :string
    add_column :projects, :design_phone, :string
    add_column :projects, :cost, :string
    add_column :projects, :cost_phone, :string
    add_column :projects, :settling, :string
    add_column :projects, :settling_phone, :string
    add_column :projects, :constructor, :string
    add_column :projects, :constructor_phone, :string
    add_column :projects, :supervisor, :string
    add_column :projects, :supervisor_phone, :string
  end
end
