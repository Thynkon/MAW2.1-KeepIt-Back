class User < ApplicationRecord
  include Rodauth::Rails.model

  enum :status, unverified: 1, verified: 2, closed: 3

  self.serializable_fields = [:id, :username, :email]

  has_many :user_votes_books
  has_many :user_has_achievements
  has_many :achievements, through: :user_has_achievements
  has_many :user_has_friends

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  def invitations
    UserHasFriend.not_confirmed.where(friend_id: id)#, confirmed: false)
  end

  def friends
    friends_invited = UserHasFriend.confirmed.where(user_id: id).pluck(:friend_id)
    friends_inviting = UserHasFriend.confirmed.where(friend_id: id).pluck(:user_id)

    ids = friends_invited + friends_inviting

    User.where(id: ids)
  end

  def friend?(user)
    UserHasFriend.confirmed.where(user_id: id, friend_id: user.id).exists?
  end

  def send_invitation(user)
    UserHasFriend.create(user_id: id, friend_id: user.id)
  end

  def accept_invitation(invitation)
    invitation.update(confirmed: true)
  end

  def deny_invitation(invitation)
    invitation.destroy
  end

  def has_invited?(user)
    UserHasFriend.where(user_id: id, friend_id: user.id).exists?
  end

  def friend?(user)
      friends.include?(user)
  end
end
