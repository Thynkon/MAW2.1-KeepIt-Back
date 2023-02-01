class UserVotesBook < ApplicationRecord
    belongs_to :user

    @@donwvote = -1
    @@upvote = 1

    validates :vote, presence: true, inclusion: { in: [@@donwvote, @@upvote] }
end