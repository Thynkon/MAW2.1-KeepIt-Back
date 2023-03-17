require "rails_helper"

describe Books::GoogleBooksApi::Client do
  before do
    @book_client = described_class.new
  end

  RSpec::Matchers.define :contain_subject do |expected_value|
    match do |actual|
      status = actual[:subjects].map do |category|
        category.downcase.include?(expected_value.downcase)
      end

      status.all?
    end
  end

  RSpec::Matchers.define :contain_cover do
    match do |actual|
      !actual[:cover].nil?
    end
  end

  RSpec::Matchers.define :contain_title do |expected_value|
    match do |actual|
      actual[:title].downcase.include?(expected_value.downcase)
    end
  end

  describe "all" do
    before do
      @max = 10
      @subject = "fiction"
      @books = @book_client.all(max: @max, subject: @subject)
    end

    it "fetches 10 books of a category named 'fiction'" do
      # Given

      # When

      # Then
      expect(@books.length).to be(@max)
      expect(@books).to all(contain_subject(@subject))
      expect(@books).to all(contain_cover)
    end
  end

  describe "by_id" do
    before do
      @id = "OXNUEAAAQBAJ"
      @book = @book_client.by_id(id: @id)
    end

    it "fetches book by id" do
      # Given

      # When

      # Then
      expect(@book[:id]).to eq(@id)
    end
  end

  describe "by_title" do
    before do
      @title = "lupin"
      @max = 5
      @books = @book_client.by_title(title: @title, max: @max)
    end

    it "fetches 5 books whose title contains 'lord'" do
      # Given

      # When

      # Then
      expect(@books.length).to be(@max)
      expect(@books).to all(contain_title(@title))
    end
  end
end
