class AddColumnCompanyIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :company_id, :integer
    add_column :projects, :category_id, :integer
  end
end
