class SeasonsController < ApplicationController
  def initialize
    @tmdb_client = TheMovieDbClient.new
  end

  def show
    @season = @tmdb_client.season_by_number(show_id:params[:show_id], season_id:params[:id])
  end
end