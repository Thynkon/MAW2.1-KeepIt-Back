require 'async'

class GoogleBooksApiClient
  def initialize
  end

  def all(max: 10, offset: 0, subject: "any")
    url = Rails.configuration.book_api_url
    key = Rails.application.credentials.google_books_api_key

    task = Async do
      HTTP.headers(:accept => "application/json")
          .get("#{url}/volumes?q=subject:any&orderBy=newest&maxResults=#{max}&startIndex=#{offset}&key=#{key}")
    end

    response = task.wait
    parsed_response = JSON.parse(response.body)
    if parsed_response.key?("items")
      parsed_response["items"].map do |book|
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
          upvotes: rand(10..1_000_000),
          downvotes: rand(10..1_000_000),
        }
      end
    else
      []
    end
  end
end