require 'swagger_helper'

RSpec.describe 'Books API', type: :request do

  path '/books' do
    get 'Retrieves a list of books' do
      tags 'Books'
      produces 'application/json'

      response '200', 'books found' do
        run_test!
        schema '$ref' => '#/components/schemas/books'
      end
    end
  end

  path '/books/search' do
    get 'Retrieves a list of books' do
      tags 'Books'
      produces 'application/json'
      parameter name: 'q', required: true, in: :query, type: :string, description: 'Book title'

      response '200', 'books found' do
        run_test!
        schema '$ref' => '#/components/schemas/books'
      end
    end
  end

  path '/book/{id}' do
    get 'Retrieves a book' do
      tags 'Book'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'books found' do
        let(:id) { "ljNVEAAAQBAJ"}
        run_test!
        schema '$ref' => '#/components/schemas/book'
      end
    end
  end

  # Votes
  path '/book/{id}/upvote' do
    put 'Upvotes a book' do
      tags 'Book'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string

      response '201', 'book upvoted' do
        run_test!
      end
    end
  end

  path '/book/{id}/downvote' do
    put 'Downvotes a book' do
      tags 'Book'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string

      response '201', 'book downvoted' do
        run_test!
      end
    end
  end

  path '/book/{id}/unvote' do
    delete 'Unvotes a book' do
      tags 'Book'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string

      response '201', 'book downvoted' do
        run_test!
      end
    end
  end

  path '/book/{id}/unvote' do
    put 'Tracks a book progression' do
      tags 'Book'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string

      response '201', 'book tracked' do
        run_test!
      end
    end
  end
end