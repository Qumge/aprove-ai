class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.integer :model_id
      t.string :model_type
      t.string :status
      t.timestamps null: false
    end
  end
end
