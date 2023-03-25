class UserHasFriendPolicy < ApplicationPolicy
  attr_reader :user, :invitation

  # _record in this example will just be :dashboard
  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def accept?
    @user == @invitation.friend
  end
  
  def destroy?
    @user == @invitation.friend || @user == @invitation.user
  end
end