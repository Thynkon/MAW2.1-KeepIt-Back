require 'async'

class OpenLibraryClient < BookClient
  def initialize
  end

  def all(max:, offset: 0, subject: "any")
    url = Rails.configuration.book_api_url
    key = Rails.application.credentials.google_books_api_key

    task = Async do
      HTTP.headers(:accept => "application/json")
          .get("#{url}/volumes?q=subject:any&orderBy=newest&maxResults=#{max}&index=#{offset}&key=#{key}")
    end

    response = task.wait
    parsed_response = JSON.parse(response.body)
    parsed_response["items"].map do |book|
      {
        id: book["id"],
        title: book["volumeInfo"]["title"],
        published_at: book["volumeInfo"]["publishedDate"],
        cover: book["volumeInfo"]["thumbnail"],
        subjects: book["volumeInfo"]["categories"],
        upvotes: rand(1..100),
        downvotes: rand(1..100),
      }
    end
  end
end