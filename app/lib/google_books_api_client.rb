require 'async'

class GoogleBooksApiClient
  def initialize
    @qb = GoogleBooksQueryBuilder.new
  end

  def all(max: 10, offset: 0, subject: nil)
    subjects = [
      "authors",
      "fiction",
      "inspirational",
      "love",
      "poetry",
      "romance"
    ]

    if subject.nil?
      subject = subjects.sample
    end

    if (max < GoogleBooksQueryBuilder::VALID_MAX.begin)
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif (max > GoogleBooksQueryBuilder::VALID_MAX.last)
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    query = @qb.where(:subject, subject)
              .max(max)
              .offset(offset)
              .order_by(:newest)
              .build

    send(query)
  end

  def by_title(title: "", max: 10, offset: 0)
    if (max < GoogleBooksQueryBuilder::VALID_MAX.begin)
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif (max > GoogleBooksQueryBuilder::VALID_MAX.last)
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    query = @qb.where(:title, title)
              .max(max)
              .offset(offset)
              .order_by(:newest)
              .build

    send(query)
  end

  private

  def fetch_response(response)
    if response.key?("items")
      response["items"].map do |book|
        {
          id: book["id"],
          title: book["volumeInfo"]["title"],
          description: book["volumeInfo"]["description"],
          url: book.dig("volumeInfo", "selfLink"),
          authors: book["volumeInfo"]["authors"],
          cover: book.dig("volumeInfo", "imageLinks", "thumbnail"),
          subjects: book["volumeInfo"]["categories"],
          language: book["volumeInfo"]["language"],
          number_of_pages: book["volumeInfo"]["pageCount"],
          published_at: book["volumeInfo"]["publishedDate"],
          upvotes: rand(10..10_000_000), # random for now, should be fetched from database
          downvotes: rand(10..10_000_000) # random for now, should be fetched from database
        }
      end
    else
      []
    end
  end

  def send(query)
    task = Async do
      HTTP.headers(:accept => "application/json")
          .get(query)
    end

    response = task.wait
    parsed_response = JSON.parse(response.body)
    fetch_response(parsed_response)
  end
end