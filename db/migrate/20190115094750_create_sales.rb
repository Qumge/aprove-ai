class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :product_id
      t.float :price
      t.integer :contract_id
      t.string :desc
      t.timestamps null: false
    end
  end
end
