class CoverFilter < BookFilter
    def handle(books)
        # First, we filter books by cover
        books_with_cover = filter_books(books, filter: :cover)
        if books_with_cover.length == @max
          books = books
        else
          # Unless all books have descriptions
          until books_with_cover.length == @max
            number_of_books_without_cover = @max - books_with_cover.length
            task = Async do
              HTTP.headers(accept: 'application/json')
                  .get(@qb.offset(number_of_books_without_cover + books_with_cover.length).build)
            end

            response = task.wait
            parsed_response = JSON.parse(response.body)["items"]

            new_books_with_cover = filter_books(parsed_response, filter: :description, length: number_of_books_without_cover)
            books_with_cover.concat(new_books_with_cover)
          end
          books = books_with_cover
        end

        super(books)
    end
end