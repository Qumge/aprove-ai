class AddColumnToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :from_status, :string
    add_column :audits, :to_status, :string
    add_column :audits, :user_id, :integer
    add_column :audits, :content, :string
  end
end
