class CreateSignLogs < ActiveRecord::Migration
  def change
    create_table :sign_logs do |t|
    	t.integer :order_id
      t.integer :user_id
      t.datetime :sign_at
      t.timestamps null: false
    end
  end
end
