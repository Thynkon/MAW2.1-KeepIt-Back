class Achievement < ApplicationRecord
  has_many :user_has_achievements
  has_many :users, through: :user_has_achievements

  def percentage
    rand(0..100)
  end
end
