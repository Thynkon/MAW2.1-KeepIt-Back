class BooksController < ApplicationController
  rescue_from ArgumentError, with: :handle_query_builder
  def index
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = GoogleBooksApiClient.new
    @books = @book_client.all(max: max, offset: offset)
  end

  protected
  def handle_query_builder(exception)
    render "errors/error", format: :json, locals: { exception: exception, code: 400}, status: :bad_request
  end
end
