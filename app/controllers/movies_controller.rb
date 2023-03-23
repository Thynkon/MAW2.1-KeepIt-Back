class MoviesController < ApplicationController

  before_action :authenticate, only: [:upvote, :downvote, :unvote, :track]
  before_action :setup_user_variables


  def initialize
    super
    @tmdb_client = TheMovieDbClient.new
  end

  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @movies = @tmdb_client.by_title(type: :movie, title:query, page:page)

    render "movies/search", format: :json
  end

  def show
    movie_id = params[:id]
    @movie = @tmdb_client.by_id(type: :movie, id:movie_id)

    # inject the user's vote and track
    @user_votes_movie = UserVotesMovie.find_by(user_id: @user&.id, movie_id:)
    @user_watches_movie = UserWatchesMovie.find_by(user_id: @user&.id, movie_id:)
  end

  def popular
    page = params.key?(:page) ? params[:page] : 1

    @movies = @tmdb_client.popular(type: :movie, page:page)

    render "movies/search", format: :json
  end

  def upvote
    vote(UserVotesMovie::UPVOTE)
    render plain: "OK"
  end

  def downvote
    vote(UserVotesMovie::DOWNVOTE)
    render plain: "OK"
  end

  def unvote
    movie_id = params[:id]

    @user_votes_movie = UserVotesMovie.find_by(user_id: @user.id, movie_id:)
    @user_votes_movie.destroy
    render plain: "OK"
  end

  def track
    raise ArgumentError, "Missing query parameter 'time'" unless params.key?('time')

    time = params["time"]
    movie_id = params["id"]

    @user_watches_film = UserWatchesMovie.find_or_initialize_by(user_id: @user.id, movie_id:)
    @user_watches_film.time = time
    @user_watches_film.save!
  end

  protected

  def vote(vote)
    movie_id = params[:id]

    @user_votes_movie = UserVotesMovie.find_or_initialize_by(user_id: @user.id, movie_id:)
    @user_votes_movie.vote = vote
    @user_votes_movie.save
  end

  def setup_user_variables
    @user = current_user
  end
end