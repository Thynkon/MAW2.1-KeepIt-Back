class CreateRodauthJwtRefresh < ActiveRecord::Migration[7.0]
  def change
    # Used by the jwt refresh feature
    create_table :user_jwt_refresh_keys do |t|
      t.references :user, foreign_key: true, null: false
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.index :user_id, name: "user_jwt_rk_user_id_idx"
    end
  end
end
