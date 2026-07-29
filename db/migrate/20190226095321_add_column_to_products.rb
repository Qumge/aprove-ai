class AddColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :brand, :string
    add_column :products, :norms, :string
    add_column :products, :market_price, :float
    add_column :products, :acquisition_price, :float
    add_column :products, :freight, :float
    add_column :products, :product_category_id, :integer
    add_column :products, :color, :string
    add_column :products, :desc, :text
  end
end
