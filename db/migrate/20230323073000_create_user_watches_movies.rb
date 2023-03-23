class CreateUserWatchesMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :user_watches_movies do |t|
      t.integer :time, min: 0
      t.references :user, null: false, foreign_key: true
      t.integer :movie_id, null: false, index: true

      t.timestamps
    end
  end
end
