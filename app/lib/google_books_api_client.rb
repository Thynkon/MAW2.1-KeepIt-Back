require 'async'

class GoogleBooksApiClient
  def initialize
  end

  def all(max: 10, offset: 0, subject: "any")
    url = Rails.configuration.book_api_url
    key = Rails.application.credentials.google_books_api_key

    if (max < GoogleBooksQueryBuilder::VALID_MAX.begin)
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif (max > GoogleBooksQueryBuilder::VALID_MAX.last)
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    qb = GoogleBooksQueryBuilder.new
    query = qb.where(:subject, "any")
              .max(max)
              .offset(offset)
              .order_by(:newest)
              .build

    task = Async do
      HTTP.headers(:accept => "application/json")
          .get(query)
    end

    response = task.wait
    parsed_response = JSON.parse(response.body)
    fetch_response(parsed_response)
  end

  def by_title(title: "", max: 10, offset: 0)
    url = Rails.configuration.book_api_url
    key = Rails.application.credentials.google_books_api_key

    if (max < GoogleBooksQueryBuilder::VALID_MAX.begin)
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif (max > GoogleBooksQueryBuilder::VALID_MAX.last)
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    qb = GoogleBooksQueryBuilder.new
    query = qb.where(:intitle, title)
              .max(max)
              .offset(offset)
              .order_by(:newest)
              .build

    task = Async do
      HTTP.headers(:accept => "application/json")
          .get(query)
    end

    response = task.wait
    puts "Got response body ==> #{response.body.inspect}"

    parsed_response = JSON.parse(response.body)
    fetch_response(parsed_response)
  end

  private

  def fetch_response(response)
    if response.key?("items")
      response["items"].map do |book|
        {
          id: book["id"],
          title: book["volumeInfo"]["title"],
          description: book["volumeInfo"]["description"],
          url: book["volumeInfo"]["selfLink"],
          authors: book["volumeInfo"]["authors"],
          cover: book["volumeInfo"]["thumbnail"],
          subjects: book["volumeInfo"]["categories"],
          language: book["volumeInfo"]["language"],
          number_of_pages: book["volumeInfo"]["pageCount"],
          published_at: book["volumeInfo"]["publishedDate"],
          upvotes: rand(10..10_000_000),
          downvotes: rand(10..10_000_000)
        }
      end
    else
      []
    end
  end
end