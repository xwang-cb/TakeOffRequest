class InitializeTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :status
      t.date :joined_date
    end

    create_table :details do |t|
      t.string :user_id
      t.integer :hours
      t.string :type
      t.timestamps :start_time
    end

    create_table :summaries do |t|
      t.integer :year
      t.string :type
      t.integer :taken
      t.integer :left_last_year
      t.date :clean_date
    end
  end
end
