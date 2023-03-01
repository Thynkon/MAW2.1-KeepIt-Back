class AddUsernameToUsers < ActiveRecord::Migration[7.0]
  def change
    # Add a username column to the users table.
    add_column :users, :username, :string
    add_index :users, :username, unique: true
  end
end
