class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_at, :datetime
    add_column :orders, :payment_id, :integer
    add_column :projects, :shipment_end, :datetime
  end
end
