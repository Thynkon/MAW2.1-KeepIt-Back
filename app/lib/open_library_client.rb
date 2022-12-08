class OpenLibraryClient < BookClient
  def initialize
  end

  def by_id(id)
    url = Rails.configuration.book_api_url

    response = HTTP.headers(:accept => "application/json")
    .get("#{url}?bibkeys=ISBN:#{id}&jscmd=details&format=json")

    if response.status.success?
        book = JSON.parse(response.body)
        if book.empty?
            raise BookNotFoundError.new("No book with isbn13 `#{id}` was found")
        else
            JSON.parse(response.body)
        end
    else
        raise StandardError.new("Something went wrong")
    end
  end
end