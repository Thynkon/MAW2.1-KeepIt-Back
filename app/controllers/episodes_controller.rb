class EpisodesController < ApplicationController
  def initialize
    @tmdb_client = TheMovieDbClient.new
  end

  def show
    @episode = @tmdb_client.episode_by_number_in_season(show_id:params[:show_id],season_number:params[:season_id],episode_number:params[:id])
  end
end