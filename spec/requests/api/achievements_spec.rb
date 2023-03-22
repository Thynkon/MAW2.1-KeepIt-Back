require 'swagger_helper'

RSpec.describe 'Books API', type: :request do

  path '/achievements' do
    get 'Retrieves a list of achievements of the current user' do
      tags 'Achievements'
      security [Bearer: {}]
      produces 'application/json'

      response '200', 'achievements found' do
        run_test!
        schema '$ref' => '#/components/schemas/achievements'
      end
    end
  end

  path '/achievements/{id}' do
    get 'Retrieves an achievement' do
      tags 'Achievements'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :string

      response '200', 'achievements found' do
        let(:id) { "1"}
        run_test!
        schema '$ref' => '#/components/schemas/achievement'
      end
    end
  end

  # Achievements
  path '/users/{user_id}/achievements' do
    get 'Revieves users achievements' do
      tags 'Achievements'
      security [Bearer: {}]
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      response '200', 'book upvoted' do
        schema '$ref' => '#/components/schemas/achievements'
      end
    end
  end

  path '/users/{user_id}/achievements/{id}' do
    get 'Revieves users achievements' do
      tags 'Achievements'
      security [Bearer: {}]
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      response '200', 'book upvoted' do
        schema '$ref' => '#/components/schemas/achievement'
      end
    end
  end
end