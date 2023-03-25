class CreateUserHasFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :user_has_friends do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.boolean :confirmed, null: false, default: false

      t.timestamps
    end
  end
end
