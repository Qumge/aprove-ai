class AddColumnToCostsAndOrders < ActiveRecord::Migration
  def change
    add_column :orders, :factory_id, :integer
    add_column :costs, :cost_category_id, :integer
  end
end
