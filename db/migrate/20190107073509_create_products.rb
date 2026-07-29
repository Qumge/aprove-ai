class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :no
      t.string :name
      t.string :product_no
      t.string :unit
      t.float :reference_price
      t.timestamps null: false
    end
  end
end
