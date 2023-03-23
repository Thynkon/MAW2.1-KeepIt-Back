class User < ApplicationRecord
  include Rodauth::Rails.model

  enum :status, unverified: 1, verified: 2, closed: 3

  self.serializable_fields = [:id, :username, :email]

  has_many :user_votes_books
  has_many :user_has_achievements
  has_many :achievements, through: :user_has_achievements

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
