class CreateUserVotesBook < ActiveRecord::Migration[7.0]
  def change
    create_table :user_votes_books do |t|
      t.integer :vote, :limit => 1
      t.references :user, null: false, foreign_key: true
      t.string :book_id, null: false, index: true
      t.timestamps

      t.index [:user_id, :book_id], unique: true
    end
  end
end
