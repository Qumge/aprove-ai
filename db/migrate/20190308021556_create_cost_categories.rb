class CreateCostCategories < ActiveRecord::Migration
  def change
    create_table :cost_categories do |t|
      t.string :name
      t.text :desc
      t.timestamps null: false
    end
  end
end
