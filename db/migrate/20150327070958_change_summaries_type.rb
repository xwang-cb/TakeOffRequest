class ChangeSummariesType < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :summaries do |t|
        dir.up   { t.change :type, :integer }
        dir.down { t.change :type, :string }
      end
    end
  end
end
