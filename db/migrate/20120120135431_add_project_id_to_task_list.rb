class AddProjectIdToTaskList < ActiveRecord::Migration
  def change
    add_column :task_lists, :project_id, :integer
  end
end
