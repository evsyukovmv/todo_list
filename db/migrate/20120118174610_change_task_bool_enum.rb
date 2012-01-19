class ChangeTaskBoolEnum < ActiveRecord::Migration
  def up
    change_column :tasks, :state, :string, :default => "Not done"
  end

  def down
    change_column :tasks, :state, :boolean, :default => '0'
  end
end
