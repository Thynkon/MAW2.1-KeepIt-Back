class MoviesController < ApplicationController
  def initialize
    @tmdb_client = TheMovieDbClient.new
  end

  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @movies = @tmdb_client.by_title('movie', query, page)

    #render plain: @movies

    render "movies/search", format: :json
  end

  def show
    @movie = @tmdb_client.by_id('movie', params[:id])
  end
end