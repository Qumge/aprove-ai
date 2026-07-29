class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :city
      t.string :category
      t.string :a_name
      t.string :name
      t.string :address
      t.string :supplier_type
      t.boolean :strategic #是否战略
      t.integer :estimate #预估规模
      t.string :butt_name
      t.string :butt_title
      t.string :butt_phone
      t.integer :owner_id
      t.integer :create_id
      t.integer :agency_id
      t.timestamps null: false
    end
  end
end
