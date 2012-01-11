class ChangeTaskStateDefaultPriorityDefault < ActiveRecord::Migration
  def up
    change_column :tasks, :state, :boolean, :default => '0'
    change_column :tasks, :priority, :integer, :default => '0'
  end

  def down
    change_column :tasks, :state, :boolean
    change_column :tasks, :priority, :integer
  end
end
