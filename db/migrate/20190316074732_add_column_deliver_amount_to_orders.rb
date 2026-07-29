class AddColumnDeliverAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deliver_amount, :float
    add_column :projects, :deliver_amount, :float
  end
end
