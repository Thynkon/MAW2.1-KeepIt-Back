class MoviesController < ApplicationController

  before_action :authenticate, only: [:upvote, :downvote, :unvote, :track]

  def initialize
    @tmdb_client = TheMovieDbClient.new
  end

  def search
    query = params[:q]
    page = params.key?(:page) ? params[:page] : 1

    @movies = @tmdb_client.by_title(type: :movie, title:query, page:page)

    render "movies/search", format: :json
  end

  def show
    @movie = @tmdb_client.by_id(type: :movie, id:params[:id])
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
    @user = current_user

    @user_votes_movie = UserVotesMovie.find_by(user_id: @user.id, movie_id:)
    @user_votes_movie.destroy
    render plain: "OK"
  end

  protected

  def vote(vote)
    movie_id = params[:id]
    @user = current_user

    @user_votes_movie = UserVotesMovie.find_or_initialize_by(user_id: @user.id, movie_id:)
    @user_votes_movie.vote = vote
    @user_votes_movie.save
  end
end