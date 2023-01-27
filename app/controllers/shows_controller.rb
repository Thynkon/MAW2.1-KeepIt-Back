class ShowsController < ApplicationController
  def initialize
    @tmdb_client = TheMovieDbClient.new
  end

  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @shows = @tmdb_client.by_title('tv', query, page)

    #render plain: @movies

    render "shows/search", format: :json
  end

  def show
    @show = @tmdb_client.by_id('tv', params[:id])
  end
end