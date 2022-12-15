class BooksController < ApplicationController
  def all
    max = params.key?('max') ? params["max"].to_i : 10
    offset = params.key?('offset') ? params["offset"].to_i : 0

    @book_client = GoogleBookApiClient.new

    render json: @book_client.all(max: max, offset: offset)
  end
end
