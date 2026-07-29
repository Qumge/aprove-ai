class AddColumnToOrdersProjects < ActiveRecord::Migration
  def change
    add_column :orders, :user_id, :integer
    add_column :orders, :desc, :string
    add_column :orders, :order_status, :string
    add_column :projects, :project_status, :string
  end
end
