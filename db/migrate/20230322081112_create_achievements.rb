class CreateAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :achievements do |t|
      t.string :title, index: { unique: true}
      t.text :description
      t.integer :percentage, default: 0

      t.timestamps
    end
  end
end
