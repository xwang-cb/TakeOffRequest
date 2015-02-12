class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :year
      t.string :type
      t.integer :taken
      t.integer :left_last_year

      t.timestamps null: false
    end
  end
end
