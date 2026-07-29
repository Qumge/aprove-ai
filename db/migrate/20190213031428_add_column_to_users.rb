class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agent_id, :integer
    rename_column :agents, :company, :username
  end
end
