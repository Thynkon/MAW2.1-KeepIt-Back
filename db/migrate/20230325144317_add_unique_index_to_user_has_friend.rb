class AddUniqueIndexToUserHasFriend < ActiveRecord::Migration[7.0]
  def change
    add_index :user_has_friends, [:user_id, :friend_id], unique: true
  end
end
