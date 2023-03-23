require 'swagger_helper'

RSpec.describe 'Books API', type: :request do

  path '/users' do
    get 'Retrieves a list of books' do
      tags 'Users'
      produces 'application/json'

      response '200', 'books found' do
        run_test!
        schema '$ref' => '#/components/schemas/books'
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a book' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'books found' do
        let(:id) { "ljNVEAAAQBAJ"}
        run_test!
        schema '$ref' => '#/components/schemas/book'
      end
    end
  end
end