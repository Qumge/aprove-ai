class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.integer :user_id
      t.float :amount
      t.string :purpose
      t.datetime :occur_time
      t.timestamps null: false
    end
  end
end
