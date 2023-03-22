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
end