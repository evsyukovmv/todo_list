class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.integer :project_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, :project_id
    add_index :relationships, [:follower_id, :followed_id, :project_id], :unique => true, :name => "index_relationships_on_follower_followed_project"
  end
end
