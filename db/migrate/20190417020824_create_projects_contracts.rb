class CreateProjectsContracts < ActiveRecord::Migration
  def change
    create_table :projects_contracts do |t|
      t.integer :project_id
      t.integer :contract_id
      t.timestamps null: false
    end
  end
end
