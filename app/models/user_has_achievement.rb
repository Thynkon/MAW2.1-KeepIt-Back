class UserHasAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement
end
