class UserHasFriend < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :confirmed , -> { where(confirmed: true) }
  scope :not_confirmed , -> { where(confirmed: false) }
end
