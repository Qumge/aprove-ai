class CreateOrderInvoices < ActiveRecord::Migration
  def change
    create_table :order_invoices do |t|
      t.integer :invoice_id
      t.integer :order_id
      t.timestamps null: false
    end
  end
end
