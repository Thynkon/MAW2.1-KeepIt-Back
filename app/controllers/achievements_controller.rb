class AchievementsController < ApplicationController
  before_action :authenticate

  def index
    user = current_user
    @achievements = user.achievements
  end
end
