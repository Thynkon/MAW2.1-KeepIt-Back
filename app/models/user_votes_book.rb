class UserVotesBook < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  @@donwvote = -1
  @@upvote = 1

  validates :vote, presence: true, inclusion: { in: [@@donwvote, @@upvote] }
end
