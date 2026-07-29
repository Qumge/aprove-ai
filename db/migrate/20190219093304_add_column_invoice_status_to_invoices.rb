class AddColumnInvoiceStatusToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_status, :string
  end
end
