class ShowsController < ApplicationController
  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @tmdb_client = TheMovieDbClient.new
    @shows = @tmdb_client.by_title('tv', query, page)

    #render plain: @movies

    render "shows/search", format: :json
  end

  def show
    @tmdb_client = TheMovieDbClient.new
    @show = @tmdb_client.by_id('tv', params[:id])

    render "shows/show", format: :json
  end
end