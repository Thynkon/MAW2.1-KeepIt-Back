class BooksController < ApplicationController
  rescue_from ArgumentError, with: :handle_query_builder

  UP_VOTE = 1
  DOWN_VOTE = -1

  def index
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = GoogleBooksApiClient.new
    @books = @book_client.all(max: max, offset: offset)
  end

  def search
    title = params["q"]
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = GoogleBooksApiClient.new
    @books = @book_client.by_title(title: title, max: max, offset: offset)
    render "books/index", format: :json
  end
  
  def show
    book_id = params["id"]
    @user_id = 1 # TODO: user_id should be retrieved from the token

    @book_client = GoogleBooksApiClient.new
    @book = @book_client.by_id(id: book_id)

    # inject the user's vote
    @user_votes_book = UserVotesBook.find_by(user_id: 1, book_id: book_id) # TODO: user_id should be retrieved from the token
  end

  def upvote
    vote_on_a_book(UP_VOTE)
  end

  def downvote
    vote_on_a_book(DOWN_VOTE)
  end

  def unvote
    book_id = params["id"]
    user_id = params["user_id"]

    @user_votes_book = UserVotesBook.find_by(user_id: 1, book_id: book_id) # TODO: user_id should be retrieved from the token
    @user_votes_book.destroy
  end

  protected
  def handle_query_builder(exception)
    render "errors/error", format: :json, locals: { exception: exception, code: 400}, status: :bad_request
  end

  def vote_on_a_book(vote)
    book_id = params["id"]
    user_id = params["user_id"]

    puts "book_id: #{book_id}"
    puts "user_id: #{user_id}"
    
    @user_votes_book = UserVotesBook.find_or_initialize_by(user_id: 1, book_id: book_id) # TODO: user_id should be retrieved from the token
    @user_votes_book.vote = vote
    @user_votes_book.book_id = book_id
    @user_votes_book.save
  end
end
