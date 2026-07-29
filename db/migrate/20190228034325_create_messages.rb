class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.string :to
      t.string :from
      t.string :template_id
      t.string :status
      t.string :send_id
      t.integer :fee
      t.string :code
      t.string :msg
      t.string :type
      t.timestamps null: false
    end
  end
end
