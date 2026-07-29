class AddColumnPaymentPercentToProjects < ActiveRecord::Migration
  def change
    add_column :projects,:payment_percent, :float
    add_column :orders,:payment_percent, :float
  end
end
