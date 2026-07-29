class ChangeColumnForOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :deliver_at, :last_deliver_at
  end
end
