class ShowsController < ApplicationController
  def initialize
    @tmdb_client = TheMovieDbClient.new
  end

  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @shows = @tmdb_client.by_title(type: :tv, title:query, page:page)

    render "shows/search", format: :json
  end

  def show
    @show = @tmdb_client.by_id(type: :tv, id:params[:id])
  end

  def popular
    page = params.key?(:page) ? params[:page] : 1

    @shows = @tmdb_client.popular(type: :tv, page:page)

    render "shows/search", format: :json
  end
end