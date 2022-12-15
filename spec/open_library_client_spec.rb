require "rails_helper"

describe BookClient do
  before(:each) do
    @book_client = OpenLibraryClient.new
  end

  RSpec::Matchers.define :contain_subject do |expected_value|
    match do |actual|
      puts actual[:subjects].inspect
      status = actual[:subjects].map do |category|
        category.downcase.include?(expected_value.downcase)
      end

      status.all?
    end
  end

  describe "all" do
    before(:each) do
      @max = 10
      @books = @book_client.all(max: @max)
    end

    it "fetches 10 books of a category named 'any'" do
      # Given

      # When

      # Then
      expect(@books.length).to be(@max)
    end

    it "fetches 10 books of a category named 'any'" do
      # Given

      # When

      # Then
      expect(@books).to all( contain_subject("any") )
    end
  end
end