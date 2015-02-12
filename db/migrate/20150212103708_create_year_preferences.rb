class CreateYearPreferences < ActiveRecord::Migration
  def change
    create_table :year_preferences do |t|
      t.integer :year
      t.date :clean_date
    end
  end
end
