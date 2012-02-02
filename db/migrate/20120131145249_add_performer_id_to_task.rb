class AddPerformerIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :performer_id, :integer
  end
end
