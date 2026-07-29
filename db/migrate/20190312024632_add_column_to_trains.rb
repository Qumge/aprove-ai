class AddColumnToTrains < ActiveRecord::Migration
  def change
    add_column :trains, :action_type, :string
  end
end
