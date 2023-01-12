class GoogleBooksQueryBuilder
    VALID_ORDER_BY = [:newest, :relevance]
    VALID_WHERE = {id: :id, title: :intitle, description: :description, subject: :subject}
    VALID_MAX = (10..40)

    def initialize
        @url = Rails.configuration.book_api_url
        key = Rails.application.credentials.google_books_api_key

        @query_params = {key: key}
        @query_params[:langRestrict] = "en"
    end

    def where(field, value)
      raise ArgumentError, "Invalid where value" unless VALID_WHERE.keys.include?(field)
      q("#{VALID_WHERE[field]}:#{value}")
      self
    end
  
    def order_by(order_by)
      raise ArgumentError, "Invalid orderBy value" unless VALID_ORDER_BY.include?(order_by)
      @query_params[:orderBy] = order_by
      self
    end
  
    def offset(offset)
      @query_params[:startIndex] = offset
      self
    end
  
    def max(max)
      raise ArgumentError, "Invalid max value" unless VALID_MAX.include?(max)
      @query_params[:maxResults] = max
      self
    end
  
    def build
      query_string = @query_params.map{|k,v| "#{k}=#{v}"}.join("&")
      "#{@url}?#{query_string}".gsub(/\s/, "+")
    end

    private
    def q(query)
      @query_params[:q] = query
      self
    end
  end