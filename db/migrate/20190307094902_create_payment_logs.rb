class CreatePaymentLogs < ActiveRecord::Migration
  def change
    create_table :payment_logs do |t|
      t.integer :order_id
      t.datetime :payment_at
      t.float :amount
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
