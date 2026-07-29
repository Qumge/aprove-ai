class CreateDeliverLogs < ActiveRecord::Migration
  def change
    create_table :deliver_logs do |t|
      t.integer :order_id
      t.integer :user_id
      t.float :amount
      t.datetime :deliver_at
      t.timestamps null: false
    end
  end
end
