class AddColumnToOrdersAndInvoices < ActiveRecord::Migration
  def change
    add_column :orders, :apply_at, :datetime
    add_column :orders, :applied_at, :datetime
    add_column :invoices, :apply_at, :datetime
    add_column :invoices, :applied_at, :datetime
  end
end
