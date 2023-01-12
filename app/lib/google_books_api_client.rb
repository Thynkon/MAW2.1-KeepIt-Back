require "async"

class GoogleBooksApiClient
  def initialize
    @qb = GoogleBooksQueryBuilder.new
  end

  def all(max: 10, offset: 0, subject: nil)
    subjects = %w[
      authors
      fiction
      inspirational
      love
      poetry
      romance
    ]

    if subject.nil?
      subject = subjects.sample
    end

    if max < GoogleBooksQueryBuilder::VALID_MAX.begin
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif max > GoogleBooksQueryBuilder::VALID_MAX.last
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    query = @qb.where(:subject, subject)
      .max(max)
      .offset(offset)
      .order_by(:newest)
      .build

    send(query)
  end

  def by_id(id: "")
    query = @qb.where(:id, id)
      .build

    send(query)
  end

  def by_title(title: "", max: 10, offset: 0)
    if max < GoogleBooksQueryBuilder::VALID_MAX.begin
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif max > GoogleBooksQueryBuilder::VALID_MAX.last
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
          downvotes: rand(10..10_000_000), # random for now, should be fetched from database
        }
      end
    else
      []
    end
  end

  def send(query)
    task = Async do
      HTTP.headers(accept: "application/json")
        .get(query)
    end

    response = task.wait
    books = JSON.parse(response.body)
    books_with_cover = []

    books_without_cover = fetch_books(books, with_cover: false)

    if books_without_cover.empty?
      fetch_response(books)
    else
      # Unless all books have cover images
      unless books_without_cover.empty?
        task = Async do
          HTTP.headers(accept: "application/json")
            .get(@qb.offset(books_without_cover.length).build)
        end

        response = task.wait
        parsed_response = JSON.parse(response.body)

        books_with_cover.concat(fetch_books(parsed_response, with_cover: true))
        books_without_cover = fetch_books(parsed_response, with_cover: false)
      end

      fetch_response(books_with_cover)
    end
  end

  def fetch_books(books, with_cover: true)
    books["items"].select do |book|
      if with_cover
        !book.dig("volumeInfo", "imageLinks",
                  "thumbnail").nil?
      else
        book.dig("volumeInfo", "imageLinks", "thumbnail").nil?
      end
    end
  end
end
