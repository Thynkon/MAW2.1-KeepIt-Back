# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_25_144317) do
  create_table "achievements", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "percentage", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_achievements_on_title", unique: true
  end

  create_table "user_has_achievements", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "achievement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_has_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_user_has_achievements_on_user_id"
  end

  create_table "user_has_friends", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id", null: false
    t.boolean "confirmed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_user_has_friends_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_user_has_friends_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_user_has_friends_on_user_id"
  end

  create_table "user_jwt_refresh_keys", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.index ["user_id"], name: "index_user_jwt_refresh_keys_on_user_id"
    t.index ["user_id"], name: "user_jwt_rk_user_id_idx"
  end

  create_table "user_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "user_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "user_reads_books", force: :cascade do |t|
    t.integer "page"
    t.integer "user_id", null: false
    t.string "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_user_reads_books_on_book_id"
    t.index ["user_id"], name: "index_user_reads_books_on_user_id"
  end

  create_table "user_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "user_votes_books", force: :cascade do |t|
    t.integer "vote", limit: 1
    t.integer "user_id", null: false
    t.string "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_user_votes_books_on_book_id"
    t.index ["user_id", "book_id"], name: "index_user_votes_books_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_user_votes_books_on_user_id"
  end

  create_table "user_votes_movies", force: :cascade do |t|
    t.integer "vote", limit: 1
    t.integer "user_id", null: false
    t.string "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_user_votes_movies_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_user_votes_movies_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_user_votes_movies_on_user_id"
  end

  create_table "user_votes_shows", force: :cascade do |t|
    t.integer "vote", limit: 1
    t.integer "user_id", null: false
    t.string "show_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_user_votes_shows_on_show_id"
    t.index ["user_id", "show_id"], name: "index_user_votes_shows_on_user_id_and_show_id", unique: true
    t.index ["user_id"], name: "index_user_votes_shows_on_user_id"
  end

  create_table "user_watches_episodes", force: :cascade do |t|
    t.integer "time"
    t.integer "user_id", null: false
    t.integer "show_id", null: false
    t.integer "season_id", null: false
    t.integer "episode_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["episode_id"], name: "index_user_watches_episodes_on_episode_id"
    t.index ["season_id"], name: "index_user_watches_episodes_on_season_id"
    t.index ["show_id"], name: "index_user_watches_episodes_on_show_id"
    t.index ["user_id"], name: "index_user_watches_episodes_on_user_id"
  end

  create_table "user_watches_movies", force: :cascade do |t|
    t.integer "time"
    t.integer "user_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_user_watches_movies_on_movie_id"
    t.index ["user_id"], name: "index_user_watches_movies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.string "email", null: false
    t.string "password_hash"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "status IN (1, 2)"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "user_has_achievements", "achievements"
  add_foreign_key "user_has_achievements", "users"
  add_foreign_key "user_has_friends", "users"
  add_foreign_key "user_has_friends", "users", column: "friend_id"
  add_foreign_key "user_jwt_refresh_keys", "users"
  add_foreign_key "user_login_change_keys", "users", column: "id"
  add_foreign_key "user_password_reset_keys", "users", column: "id"
  add_foreign_key "user_reads_books", "users"
  add_foreign_key "user_verification_keys", "users", column: "id"
  add_foreign_key "user_votes_books", "users"
  add_foreign_key "user_votes_movies", "users"
  add_foreign_key "user_votes_shows", "users"
  add_foreign_key "user_watches_episodes", "users"
  add_foreign_key "user_watches_movies", "users"
end
