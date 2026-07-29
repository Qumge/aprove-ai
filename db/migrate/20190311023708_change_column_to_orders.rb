class ChangeColumnToOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :payment_at, :last_payment_at
  end
end
