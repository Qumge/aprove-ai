class AddColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contract_id, :integer
    add_column :projects, :step, :integer, default: 0
    add_column :projects, :step_status, :string
  end
end
