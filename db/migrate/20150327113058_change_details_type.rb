class ChangeDetailsType < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :details do |t|
        dir.up   { t.change :type, :integer }
        dir.down { t.change :type, :string }
      end
    end
  end
end
