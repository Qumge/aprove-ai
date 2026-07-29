class AddColumnDeletedAt < ActiveRecord::Migration
  def change
    add_column :orders, :deleted_at, :datetime
    add_column :projects, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime
    add_column :contracts, :deleted_at, :datetime
    add_column :order_products, :deleted_at, :datetime
    add_column :products, :deleted_at, :datetime
    add_column :agents, :deleted_at, :datetime
    add_column :attachments, :deleted_at, :datetime
    add_column :organizations, :deleted_at, :datetime
    add_column :roles, :deleted_at, :datetime
    add_column :resources, :deleted_at, :datetime
    add_column :sales, :deleted_at, :datetime

    add_index :orders, :deleted_at
    add_index :projects, :deleted_at
    add_index :users, :deleted_at
    add_index :contracts, :deleted_at
    add_index :order_products, :deleted_at
    add_index :products, :deleted_at
    add_index :agents, :deleted_at
    add_index :attachments, :deleted_at
    add_index :organizations, :deleted_at
    add_index :roles, :deleted_at
    add_index :resources, :deleted_at
    add_index :sales, :deleted_at

  end
end
