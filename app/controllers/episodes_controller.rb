class EpisodesController < ApplicationController

  before_action :authenticate, only: [:track]
  before_action :setup_user_variables


  def initialize
    super
    @tmdb_client = TheMovieDbClient.new
  end

  def show
    episode_id = params[:id]
    season_id = params[:season_id]
    show_id = params[:show_id]

    @episode = @tmdb_client.episode_by_number_in_season(show_id:,season_id:,episode_id:)
    @user_watches_episode = UserWatchesEpisode.find_by(user_id: @user&.id, show_id:,season_id:,episode_id:)
  end

  def track
    raise ArgumentError, "Missing query parameter 'time'" unless params.key?('time')

    Rails.logger.debug("Params: #{params.inspect}")

    time = params["time"]
    episode_id = params["id"]
    season_id = params["season_id"]
    show_id = params["show_id"]

    @user_watches_episode = UserWatchesEpisode.find_or_initialize_by(user_id: @user.id, show_id:,season_id:,episode_id:)
    @user_watches_episode.time = time
    @user_watches_episode.save!
  end

  protected

  def setup_user_variables
    @user = current_user
  end
end