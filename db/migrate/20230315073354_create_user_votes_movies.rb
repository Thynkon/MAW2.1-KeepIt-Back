class CreateUserVotesMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :user_votes_movies do |t|
      t.integer :vote, :limit => 1
      t.references :user, null: false, foreign_key: true
      t.string :movie_id, null: false, index: true
      t.timestamps

      t.index [:user_id, :movie_id], unique: true
    end
  end
end