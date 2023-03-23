class UserWatchesMovie < ApplicationRecord
    validates :time, presence: true, numericality: { only_integer: true, greater_than: 0 }

    belongs_to :user
end