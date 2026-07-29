class AddColumnTotalPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_price, :float
  end
end
