class AddColumnDeliverAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deliver_at, :datetime
  end
end
