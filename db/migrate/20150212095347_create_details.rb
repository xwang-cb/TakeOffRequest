class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :user_id
      t.integer :hours
      t.string :type
      t.datetime :start_date

      t.timestamps null: false
    end
  end
end
