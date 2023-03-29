class UserHasFriendPolicy < ApplicationPolicy
  attr_reader :user, :invitation

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def create?
    @user == @invitation.user && @user != @invitation.friend
  end

  def accept?
    @user == @invitation.friend
  end
  
  def destroy?
    @user == @invitation.friend || @user == @invitation.user
  end
end