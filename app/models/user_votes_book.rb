class UserVotesBook < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"

  UPVOTE = Rails.application.config.upvote
  DOWNVOTE = Rails.application.config.downvote

  validates :vote, presence: true, inclusion: { in: [UPVOTE, DOWNVOTE] }
end
