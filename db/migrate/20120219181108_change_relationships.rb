class ChangeRelationships < ActiveRecord::Migration
  def up
    remove_column :relationships, :follower_id
    remove_column :relationships, :followed_id
    add_column :relationships, :user_id, :integer
  end

  def down
    remove_column :relationships, :user_id
    add_column :relationships, :follower_id, :integer
    add_column :relationships, :followed_id, :integer
  end
end
