class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :number
      t.float :price
      t.float :total_price
      t.float :discount
      t.float :discount_price
      t.float :discount_total_price
      t.timestamps null: false
    end
  end
end
