require 'swagger_helper'

RSpec.describe 'Shows API', type: :request do

  path '/shows/popular' do
    get 'Retrieves a list of popular shows' do
      tags 'Shows'
      produces 'application/json'
      parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false

      response '200', 'shows found' do
        run_test!
        schema '$ref' => '#/components/schemas/shows'
      end
    end
  end

  path '/shows/search' do
    get 'Retrieves a list of shows' do
      tags 'Shows'
      produces 'application/json'
      parameter name: 'q', required: true, in: :query, type: :string, description: 'Show title'
      parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false

      response '200', 'shows found' do
        run_test!
        schema '$ref' => '#/components/schemas/shows'
      end
    end
  end

  path '/shows/{id}' do
    get 'Retrieves a show' do
      tags 'Shows'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'show found' do
        let(:id) { 57243 }
        run_test!
        schema '$ref' => '#/components/schemas/show'
      end
    end
  end

  # Votes
  path '/shows/{id}/upvote' do
    put 'Upvotes a show' do
      tags 'Shows'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'show upvoted' do
        let(:id) { 57243 }
        run_test!
      end
    end
  end

  path '/shows/{id}/downvote' do
    put 'Downvotes a show' do
      tags 'Shows'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'show downvoted' do
        let(:id) { 57243 }
        run_test!
      end
    end
  end

  path '/shows/{id}/unvote' do
    delete 'Unvotes a show' do
      tags 'Shows'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'show downvoted' do
        let(:id) { 57243 }
        run_test!
      end
    end
  end

  path '/shows/{show_id}/seasons/{id}' do
    get 'Retrieves a show' do
      tags 'Shows'
      produces 'application/json'
      parameter name: :show_id, in: :path, type: :integer, description: 'show id'
      parameter name: :id, in: :path, type: :integer, description: 'season id, the number of the season in the show'

      response '200', 'season found' do
        let(:id) { 1 }
        let(:id) { 57_243 }
        run_test!
      end
    end
  end

  path '/shows/{show_id}/seasons/{season_id}/episodes/{id}' do
    get 'Retrieves an episode' do
      tags 'Shows'
      produces 'application/json'
      parameter name: :show_id, in: :path, type: :integer, description: 'show id'
      parameter name: :season_id, in: :path, type: :integer, description: 'season id, the number of the season in the show'
      parameter name: :id, in: :path, type: :integer, description: 'episode id, the number of the episode in the season'

      response '200', 'episode found' do
        let(:show_id) { 57_243 }
        let(:season_id) { 1 }
        let(:id) { 1 }
        run_test!
      end
    end
  end

  path '/shows/{show_id}/seasons/{season_id}/episodes/{id}/track' do
    put 'Tracks an episode progression' do
      tags 'Shows'
      security [Bearer: {}]
      parameter name: :show_id, in: :path, type: :integer, description: 'show id'
      parameter name: :season_id, in: :path, type: :integer, description: 'season id, the number of the season in the show'
      parameter name: :id, in: :path, type: :integer, description: 'episode id, the number of the episode in the season'

      response '200', 'episode tracked' do
        let(:show_id) { 57_243 }
        let(:season_id) { 1 }
        let(:id) { 1 }
        run_test!
      end
    end
  end
end