module Books
  module GoogleBooksApi
    module Filters
      class BookFilter
        attr_writer :next_handler

        def initialize(max:, qb:)
            @max = max
            @qb = qb
        end

        def next_handler(handler)
          @next_handler = handler
          handler
        end

        def handle(books)
          return @next_handler.handle(books) if @next_handler

          books
        end
        
        protected
        def filter_books(books, filter: nil, presence: true, length: 0)
          b = books.select do |book|
            if filter == :description
              if presence
                !book.dig('volumeInfo', 'description').nil?
              else
                book.dig('volumeInfo', 'description').nil?
              end
            elsif filter == :cover
              if presence
                !book.dig('volumeInfo', 'imageLinks', 'thumbnail').nil?
              else
                book.dig('volumeInfo', 'imageLinks', 'thumbnail').nil?
              end
            end
          end

          if length != 0
            b.first(length)
          else
            b
          end
        end
      end
    end
  end
end