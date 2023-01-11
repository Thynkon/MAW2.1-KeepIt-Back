require "rails_helper"

describe GoogleBooksQueryBuilder do
  setup do
    @builder = GoogleBooksQueryBuilder.new
  end

  after do
    @builder = nil
  end

  describe "#where" do
    it "sets the search query parameter" do
      @builder.where(:title, "ruby programming")
      expect(@builder.instance_variable_get(:@query_params)[:q]).to eq("intitle:ruby programming")
    end

    it "raises an error for an invalid where value" do
      expect { @builder.where(:published_date, DateTime.now.utc) }.to raise_error(ArgumentError)
    end
  end

  describe "#order_by" do
    it "sets the order_by parameter" do
      @builder.order_by(:newest)
      expect(@builder.instance_variable_get(:@query_params)[:orderBy]).to eq(:newest)
    end

    it "raises an error for an invalid orderBy value" do
      expect { @builder.order_by(:invalid) }.to raise_error(ArgumentError)
    end
  end

  describe "#offset" do
    it "sets the offset parameter" do
      @builder.offset(10)
      expect(@builder.instance_variable_get(:@query_params)[:startIndex]).to eq(10)
    end
  end

  describe "#max" do
    it "sets the max parameter" do
      @builder.max(15)
      expect(@builder.instance_variable_get(:@query_params)[:maxResults]).to eq(15)
    end

    it "raises an error for an invalid max value" do
      # Values can only be between 10 and 40
      expect { @builder.max(9) }.to raise_error(ArgumentError)
      expect { @builder.max(41) }.to raise_error(ArgumentError)
    end
  end

  describe "#build" do
    before do
      @key = Rails.application.credentials.google_books_api_key
    end

    it "constructs the correct query URL" do
      query_url = @builder.where(:title, "ruby programming").order_by(:newest).build
      expect(query_url).to eq("https://www.googleapis.com/books/v1/volumes?key=#{@key}&q=intitle:ruby+programming&orderBy=newest")
    end
  end
end


