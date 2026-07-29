class AddColumnNoToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :no, :string
  end
end
