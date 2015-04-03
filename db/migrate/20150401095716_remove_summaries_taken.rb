class RemoveSummariesTaken < ActiveRecord::Migration
  def change
    remove_column :summaries, :taken, :integer
  end
end
