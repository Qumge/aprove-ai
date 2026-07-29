class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.string :name
      t.string :desc
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
