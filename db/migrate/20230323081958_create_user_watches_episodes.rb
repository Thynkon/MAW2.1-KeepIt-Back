class CreateUserWatchesEpisodes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_watches_episodes do |t|
      t.integer :time, min: 0
      t.references :user, null: false, foreign_key: true
      t.integer :show_id, null: false, index: true
      t.integer :season_id, null: false, index: true
      t.integer :episode_id, null: false, index: true

      t.timestamps
    end
  end
end
