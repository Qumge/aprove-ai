class CreateDelivers < ActiveRecord::Migration
  def change
    create_table :delivers do |t|
      t.integer :order_id
      t.string :phone_to
      t.string :phone
      t.string :number
      t.string :name
      t.string
      t.timestamps null: false
    end
  end
end
