require 'async'

class GoogleBooksApiClient
  def initialize
    @qb = GoogleBooksQueryBuilder.new
  end

  # You may think that this code might be doing a lot of instructions
  # as the books array might be huge. But, we can only fetch, at most, 40 books from
  # the API. So, that is why we didn't put much effort on the performance side.
  def all(max: 10, offset: 0, subject: nil)
    subjects = %w[
      authors
      fiction
      inspirational
      love
      poetry
      romance
    ]

    subject = subjects.sample if subject.nil?

    if max < GoogleBooksQueryBuilder::VALID_MAX.begin
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif max > GoogleBooksQueryBuilder::VALID_MAX.last
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    query = @qb.where(:subject, subject)
               .max(max)
               .offset(offset)
               .order_by(:newest)
               .order_by(:relevance)
               .build

    books = send(query)
    books_with_cover = []
    books_without_cover = fetch_books(books, with_cover: false)

    if books_without_cover.empty?
      format_response(books)
    else
      # Unless all books have cover images
      unless books_without_cover.empty?
        task = Async do
          HTTP.headers(accept: 'application/json')
              .get(@qb.offset(books_without_cover.length).build)
        end

        response = task.wait
        parsed_response = JSON.parse(response.body)

        books_with_cover.concat(fetch_books(parsed_response, with_cover: true))
        books_without_cover = fetch_books(parsed_response, with_cover: false)
      end

      format_response(books_with_cover)
    end
  end

  def by_id(id: '')
    query = @qb.where(:id, id)
               .build

    response = send(query)
    format_response(response)
  end

  def by_title(title: '', max: 10, offset: 0)
    if max < GoogleBooksQueryBuilder::VALID_MAX.begin
      max = GoogleBooksQueryBuilder::VALID_MAX.begin
    elsif max > GoogleBooksQueryBuilder::VALID_MAX.last
      max = GoogleBooksQueryBuilder::VALID_MAX.last
    end

    query = @qb.where(:title, title)
               .max(max)
               .offset(offset)
               .order_by(:newest)
               .order_by(:relevance)
               .build

    response = send(query)
    format_response(response)
  end

  private

  def format_response(response)
    if response.key?('items')
      response['items'].map do |book|
        format_book(book)
      end
    elsif response.is_a? Hash
      format_book(response)
    else
      []
    end
  end

  def format_book(book)
    {
      id: book['id'],
      title: book['volumeInfo']['title'],
      description: book['volumeInfo']['description'],
      url: book.dig('volumeInfo', 'selfLink'),
      authors: book['volumeInfo']['authors'],
      cover: book.dig('volumeInfo', 'imageLinks', 'thumbnail'),
      subjects: book['volumeInfo']['categories'],
      language: book['volumeInfo']['language'],
      number_of_pages: book['volumeInfo']['pageCount'],
      published_at: book['volumeInfo']['publishedDate'],
      upvotes: UserVotesBook.where(book_id: book['id'], vote: 1).count,
      downvotes: UserVotesBook.where(book_id: book['id'], vote: -1).count
    }
  end

  def send(query)
    task = Async do
      HTTP.headers(accept: 'application/json')
          .get(query)
    end

    response = task.wait
    JSON.parse(response.body)
  end

  def fetch_books(books, with_cover: true)
    books['items'].select do |book|
      if with_cover
        !book.dig('volumeInfo', 'imageLinks',
                  'thumbnail').nil?
      else
        book.dig('volumeInfo', 'imageLinks', 'thumbnail').nil?
      end
    end
  end
end
