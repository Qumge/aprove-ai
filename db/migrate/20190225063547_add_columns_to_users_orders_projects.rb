class AddColumnsToUsersOrdersProjects < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :orders, :payment, :float, default: 0
    change_column :projects, :payment, :float, default: 0
    add_column :projects, :need_payment, :float, default: 0
  end
end
