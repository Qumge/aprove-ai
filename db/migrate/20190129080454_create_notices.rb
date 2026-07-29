class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :model_id
      t.string :model_type
      t.string :content
      t.boolean :readed, default: false
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
