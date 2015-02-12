class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :user_id
      t.integer :hours
      t.string :type
      t.timestamps :start_time
    end
  end
end
