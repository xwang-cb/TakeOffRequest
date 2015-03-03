class AddUserIdToSummaries < ActiveRecord::Migration
  def change
    add_column :summaries, :user_id, :integer
  end
end
