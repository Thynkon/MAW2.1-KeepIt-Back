class CreateUserVotesShows < ActiveRecord::Migration[7.0]
  def change
    create_table :user_votes_shows do |t|
      t.integer :vote, :limit => 1
      t.references :user, null: false, foreign_key: true
      t.string :show_id, null: false, index: true
      t.timestamps

      t.index [:user_id, :show_id], unique: true
    end
  end
end