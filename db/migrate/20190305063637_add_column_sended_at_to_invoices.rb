class AddColumnSendedAtToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :sended_at, :datetime
    add_column :invoices, :amount, :float
  end
end
