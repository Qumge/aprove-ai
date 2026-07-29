class CreateFundLogs < ActiveRecord::Migration
  def change
    create_table :fund_logs do |t|
    	t.integer :order_id
      t.integer :user_id
      t.datetime :fund_at
      t.timestamps null: false
    end
  end
end
