class AddColumnToSales < ActiveRecord::Migration
  def change
    add_column :sales, :discount, :float
    add_column :sales, :discount_price, :float
  end
end
