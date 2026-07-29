class CreateAuditDetails < ActiveRecord::Migration
  def change
    create_table :audit_details do |t|
      t.integer :audit_id
      t.boolean :status
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
