class BooksController < ApplicationController
  rescue_from ArgumentError, with: :handle_query_builder
  def index
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = GoogleBooksApiClient.new
    @books = @book_client.all(max: max, offset: offset)
  end

  def search
    title = params["q"]
    puts "Got title ==> #{title.inspect}"
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = GoogleBooksApiClient.new
    @books = @book_client.by_title(title: title, max: max, offset: offset)
    render "books/index", format: :json
  end

  def show
    id = params["id"]

    @book_client = GoogleBooksApiClient.new
    @book = @book_client.by_id(id: id)
  end

  protected
  def handle_query_builder(exception)
    render "errors/error", format: :json, locals: { exception: exception, code: 400}, status: :bad_request
  end
end
