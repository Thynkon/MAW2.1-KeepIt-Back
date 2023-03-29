class UserPolicy < ApplicationPolicy
  attr_reader :user, :target

  def initialize(user, target)
    @user = user
    @target = target
  end
  
  def update?
    @user == @target
  end

  def destroy?
    @user == @target
  end
end