class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :company
      t.string :city
      t.string :name
      t.string :phone
      t.string :business
      t.string :resources
      t.string :scale
      t.integer :members
      t.string :product
      t.string :achievement
      t.string :desc
      t.string :agent_status
      t.integer :user_id
      t.integer :apply_id
      t.timestamps null: false
    end
  end
end
