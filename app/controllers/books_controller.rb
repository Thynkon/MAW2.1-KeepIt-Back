require 'http'

class BooksController < ApplicationController
  Client = Books::GoogleBooksApi::Client

  before_action :authenticate, only: [:upvote, :downvote, :unvote]
  rescue_from ArgumentError, with: :handle_query_builder
  rescue_from HTTP::Error, with: :handle_http_error

  def index
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = Client.new
    @books = @book_client.all(max:, offset:)
  end

  def search
    raise ArgumentError, "Missing query parameter 'q'" unless params.key?('q')

    title = params["q"]
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = Client.new
    @books = @book_client.by_title(title:, max:, offset:)
    render "books/index", format: :json
  end
  
  def show
    book_id = params["id"]
    @user = current_user

    @book_client = Client.new
    @book = @book_client.by_id(id: book_id)

    # inject the user's vote
    @user_votes_book = UserVotesBook.find_by(user_id: @user&.id, book_id:)
    @user_reads_book = UserReadsBook.find_by(user_id: @user&.id, book_id:)
  end

  def upvote
    vote_on_a_book(UserVotesBook::UPVOTE)
  end

  def downvote
    vote_on_a_book(UserVotesBook::DOWNVOTE)
  end

  def unvote
    book_id = params["id"]
    @user = current_user

    @user_votes_book = UserVotesBook.find_by(user_id: @user.id, book_id:)
    @user_votes_book.destroy
  end

  def track
    raise ArgumentError, "Missing query parameter 'page'" unless params.key?('page')

    page = params["page"]
    book_id = params["id"]
    @user = current_user

    @user_reads_book = UserReadsBook.find_or_initialize_by(user_id: @user.id, book_id:)
    @user_reads_book.page = page
    @user_reads_book.save!
  end

  protected
  def handle_query_builder(exception)
    Rails.logger.error exception
    render "errors/error", format: :json, locals: { exception: exception, code: 400}, status: :bad_request
  end

  def handle_http_error(exception)
    render "errors/error", format: :json, locals: { exception: exception, code: 500}, status: :internal_server_error
  end

  def vote_on_a_book(vote)
    book_id = params["id"]
    @user = current_user

    @user_votes_book = UserVotesBook.find_or_initialize_by(user_id: @user.id, book_id:)
    @user_votes_book.vote = vote
    @user_votes_book.book_id = book_id
    @user_votes_book.save!
  end
end
