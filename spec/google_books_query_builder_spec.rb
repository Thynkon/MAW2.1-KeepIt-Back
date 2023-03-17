require 'rails_helper'

describe Books::GoogleBooksApi::QueryBuilder do
  before do
    @builder = described_class.new
  end

  after do
    @builder = nil
  end

  describe '#where' do
    it 'sets the search query parameter' do
      @builder.where(:title, 'ruby programming')
      expect(@builder.instance_variable_get(:@query_params)[:q]).to eq('intitle:ruby programming')
    end

    it 'raises an error for an invalid where value' do
      expect { @builder.where(:published_date, DateTime.now.utc) }.to raise_error(ArgumentError)
    end

    it 'sets the book id url parameter' do
      book_id = 'OXNUEAAAQBAJ'

      @builder.where(:id, book_id)
      expect(@builder.instance_variable_get(:@url_params)[:volumeId]).to eq(book_id)
    end
  end

  describe '#order_by' do
    it 'sets the order_by parameter' do
      @builder.order_by(:newest)
      expect(@builder.instance_variable_get(:@query_params)[:orderBy]).to eq(:newest)
    end

    it 'raises an error for an invalid orderBy value' do
      expect { @builder.order_by(:invalid) }.to raise_error(ArgumentError)
    end
  end

  describe '#offset' do
    it 'sets the offset parameter' do
      @builder.offset(10)
      expect(@builder.instance_variable_get(:@query_params)[:startIndex]).to eq(10)
    end
  end

  describe '#max' do
    it 'sets the max parameter' do
      @builder.max(15)
      expect(@builder.instance_variable_get(:@query_params)[:maxResults]).to eq(15)
    end

    it 'raises an error for an invalid max value' do
      # Values can only be between 1 and 40
      expect { @builder.max(0) }.to raise_error(ArgumentError)
      expect { @builder.max(41) }.to raise_error(ArgumentError)
    end
  end

  describe '#print_type' do
    it 'sets the print_type parameter to all' do
      @builder.print_type(:all)
      expect(@builder.instance_variable_get(:@query_params)[:printType]).to eq(:all)
    end

    it 'sets the print_type parameter to book' do
      @builder.print_type(:books)
      expect(@builder.instance_variable_get(:@query_params)[:printType]).to eq(:books)
    end

    it 'sets the print_type parameter to magazines' do
      @builder.print_type(:magazines)
      expect(@builder.instance_variable_get(:@query_params)[:printType]).to eq(:magazines)
    end

    it 'raises an error for an invalid printType value' do
      expect { @builder.print_type(:invalid) }.to raise_error(ArgumentError)
    end
  end

  describe '#build' do
    before do
      @key = Rails.application.credentials.google_books_api_key
    end

    it 'constructs the correct query URL' do
      query_url = @builder.where(:title, 'ruby programming').order_by(:newest).build
      expect(query_url).to eq("https://www.googleapis.com/books/v1/volumes?key=#{@key}&langRestrict=en&projection=full&printType=books&q=intitle:ruby+programming&orderBy=newest")
    end

    it 'constructs the correct query URL to fetch a book by an ID' do
      book_id = 'OXNUEAAAQBAJ'

      query_url = @builder.where(:id, book_id).order_by(:newest).build
      expect(query_url).to eq("https://www.googleapis.com/books/v1/volumes/#{book_id}?key=#{@key}&langRestrict=en&projection=full&printType=books&orderBy=newest")
    end
  end
end
