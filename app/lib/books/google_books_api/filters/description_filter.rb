module Books
  module GoogleBooksApi
    module Filters
      class DescriptionFilter < Books::GoogleBooksApi::Filters::BookFilter
        def handle(books)
          books = [] if books.nil?
          books_with_description = filter_books(books, filter: :description)
          if books_with_description.length == @max
            books = books
          else
            # Unless all books have descriptions
            until books_with_description.length == @max
              number_of_books_without_description = @max - books_with_description.length
              task = Async do
                HTTP.headers(accept: "application/json")
                  .get(@qb.offset(number_of_books_without_description + books_with_description.length).build)
              end

              response = task.wait
              parsed_response = JSON.parse(response.body)["items"]

              new_books_with_description = filter_books(parsed_response, filter: :description, length: number_of_books_without_description)
              books_with_description.concat(new_books_with_description)
            end
            books = books_with_description
          end

          super(books)
        end
      end
    end
  end
end
