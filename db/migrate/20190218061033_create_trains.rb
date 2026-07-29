class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.string :name
      t.string :desc
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
