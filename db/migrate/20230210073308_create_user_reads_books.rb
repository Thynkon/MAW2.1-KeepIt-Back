class CreateUserReadsBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_reads_books do |t|
      t.integer :page, min: 0
      t.references :user, null: false, foreign_key: true
      t.string :book_id, null: false, index: true

      t.timestamps
    end
  end
end
