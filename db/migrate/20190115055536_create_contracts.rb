class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :name
      t.string :partner
      t.string :product
      t.datetime :valid_date
      t.string :no
      t.string :cycle
      t.text :others
      t.integer :advance_time
      t.integer :process_time
      t.integer :settlement_time
      t.integer :tail_time
      t.timestamps null: false
    end
  end
end
