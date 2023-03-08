module Books
  module GoogleBooksApi
    class QueryBuilder
      VALID_ORDER_BY = %i[newest relevance].freeze
      VALID_WHERE = { id: :volumeId, title: :intitle, description: :description, subject: :subject }.freeze
      VALID_PRINT_TYPE = %i[all books magazines].freeze
      VALID_MAX = (1..40)

      def initialize
        @url = Rails.configuration.book_api_url
        key = Rails.application.credentials.google_books_api_key

        @url_params = {}
        @query_params = { key: }
        # We only want to look for books available in english
        @query_params[:langRestrict] = 'en'
        # Google books API has two modes: full (fetches large amounts of data) and lite
        @query_params[:projection] = 'full'

        print_type(:books)
      end

      def where(field, value)
        raise ArgumentError, "Invalid where value: #{field}" unless VALID_WHERE.key?(field)

        if field == :id
          @url_params[VALID_WHERE[field]] = value
        else
          q("#{VALID_WHERE[field]}:#{value}")
         ### @query_params[:filter] = 'partial'
        end
        self
      end

      def order_by(order_by)
        raise ArgumentError, 'Invalid orderBy value' unless VALID_ORDER_BY.include?(order_by)

        @query_params[:orderBy] = order_by
        self
      end

      def offset(offset)
        @query_params[:startIndex] = offset
        self
      end

      def max(max)
        raise ArgumentError, 'Invalid max value' unless VALID_MAX.include?(max)

        @query_params[:maxResults] = max
        self
      end

      def print_type(print_type)
        raise ArgumentError, 'Invalid printType value' unless VALID_PRINT_TYPE.include?(print_type)

        @query_params[:printType] = print_type
        self
      end

      def build
        query_string = @query_params.map { |k, v| "#{k}=#{v}" }.join('&')
        # Google books API does not accept spaces in search string
        # Reference (take a look at the 'q' param): https://developers.google.com/books/docs/v1/using#api_params
        "#{@url}#{@url_params.key?(:volumeId) ? "/#{@url_params[:volumeId]}" : ''}?#{query_string}".gsub(/\s/, '+')
      end

      private

      def q(query)
        @query_params[:q] = query
        self
      end
    end
  end
end