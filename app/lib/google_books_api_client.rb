require 'async'
require 'pp'

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

    books = books["items"]

    # Since Google Books API does not offer a way to filter books by cover and description
    # we need to filter them ourselves.
    cover_filter = CoverFilter.new(max:, qb: @qb)
    description_filter = DescriptionFilter.new(max:, qb: @qb)

    cover_filter.next_handler(description_filter)
    books = cover_filter.handle(books)

    format_response(books)
  end

  def by_id(id: '')
    query = @qb.where(:id, id)
               .build
    puts "Sending query: #{query.inspect}"

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
    format_response(response["items"])
  end

  private

  def format_response(response)
    if response.is_a? Array
      response.map do |book|
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
end
