require "rails_helper"

describe BookClient do
  before(:each) do
    @book_client = OpenLibraryClient.new
  end

  describe "by_id" do
    it "returns a book with the given ID" do
      # Given
      isbn13 = "9780980200447"
      title = "Slow reading"

      # When
      book = @book_client.by_id(isbn13)
      details = book["ISBN:#{isbn13}"]["details"]

      # Then
      expect(details["isbn_13"]).to include(isbn13)
      expect(details["title"]).to include(title)
    end

    it "raises a BookNotFoundError if the book is not found" do
      # Given
      isbn13 = "non_existing_isbn13"

      # When / Then
      expect { @book_client.by_id(isbn13) }.to raise_error(BookNotFoundError)
    end
  end
end