require 'json'

class MoviesController < ApplicationController
  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @tmdb_client = TheMovieDbClient.new
    @movies = @tmdb_client.by_title(query, page)

    #render plain: @movies

    render "movies/search", format: :json
  end

  def show
    @tmdb_client = TheMovieDbClient.new
    @movie = @tmdb_client.by_id(params[:id])

    render "movies/show", format: :json
  end
end