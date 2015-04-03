class RenameStartDateToDetails < ActiveRecord::Migration
  def change
    rename_column :details, :start_date, :start_time
  end
end
