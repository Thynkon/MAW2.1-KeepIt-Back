require 'swagger_helper'

RSpec.describe 'Books API', type: :request do

  path '/users' do
    get 'Retrieves a list of users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users found' do
        run_test!
        #schema '$ref' => '#/components/schemas/users'
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        run_test!
        #schema '$ref' => '#/components/schemas/user'
      end
    end
  end
end