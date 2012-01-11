class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.boolean :state
      t.integer :priority
      t.integer :task_list_id

      t.timestamps
    end
    add_index :tasks, :task_list_id
  end
end
