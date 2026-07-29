class AddColumnPaymentToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :payment, :string
  end
end
