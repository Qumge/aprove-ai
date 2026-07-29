class AddColumnApprovalTimeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :approval_time, :datetime
  end
end
