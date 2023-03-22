class AchievementsController < ApplicationController
  before_action :authenticate

  def index
    # If the request path is /achievements, then the user is viewing their own
    if request.path == achievements_path
      user = current_user
    else
      # Another user is viewing the achievements of another user
      user = User.find(params[:user_id])
    end

    @achievements = user.achievements
  end
end
