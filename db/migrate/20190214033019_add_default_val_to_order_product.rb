class AddDefaultValToOrderProduct < ActiveRecord::Migration
  def change
    change_column_default :order_products, :discount, 1
  end
end
