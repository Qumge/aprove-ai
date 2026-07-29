class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :no
      t.timestamps null: false
    end
  end
end
