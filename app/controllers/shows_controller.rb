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

  def upvote
    vote(UserVotesShow::UPVOTE)
    render plain: "OK"
  end

  def downvote
    vote(UserVotesShow::DOWNVOTE)
    render plain: "OK"
  end

  def unvote
    show_id = params[:id]
    @user = current_user

    @user_votes_show = UserVotesShow.find_by(user_id: @user.id, show_id:)
    @user_votes_show.destroy
    render plain: "OK"
  end

  protected

  def vote(vote)
    show_id = params[:id]
    @user = current_user

    @user_votes_show = UserVotesShow.find_or_initialize_by(user_id: @user.id, show_id:)
    @user_votes_show.vote = vote
    @user_votes_show.save
  end
end