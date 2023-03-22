class CreateUserHasAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :user_has_achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :achievement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
