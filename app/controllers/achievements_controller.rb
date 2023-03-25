class AchievementsController < ApplicationController
  before_action :authenticate

  def index
    max = params.key?('max') ? params["max"].to_i : 10
    # The offset is exposed to the API as a 1-based index, but the database
    # uses a 0-based index (ActiveRecord)
    offset = params.key?('offset') ? (params["offset"].to_i - 1) : 1

    # If the request path is /achievements, then the user is viewing their own
    if request.path == achievements_path
      user = current_user
    else
      # Another user is viewing the achievements of another user
      user = User.find(params[:user_id])
    end

    @achievements = user.achievements.limit(max).offset(offset * max)
  end
end
