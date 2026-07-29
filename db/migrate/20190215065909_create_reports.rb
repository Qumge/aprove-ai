class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :project_id
      t.string :name
      t.string :address
      t.string :builder
      t.string :project_type
      t.string :project_step
      t.string :purchase_type
      t.string :scale
      t.string :product
      t.string :supply_time
      t.string :source
      t.string :desc
      t.integer :user_id
      t.string :phone
      t.timestamps null: false
    end
  end
end
