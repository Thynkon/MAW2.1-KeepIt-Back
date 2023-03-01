class UserVotesBook < ApplicationRecord
    belongs_to :user, class_name: "Account", foreign_key: "user_id"

    @@donwvote = -1
    @@upvote = 1

    validates :vote, presence: true, inclusion: { in: [@@donwvote, @@upvote] }
end