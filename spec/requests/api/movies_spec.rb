require 'swagger_helper'

RSpec.describe 'Movies API', type: :request do

  path '/movies/popular' do
    get 'Retrieves a list of popular movies' do
      tags 'Movies'
      produces 'application/json'
      parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false

      response '200', 'movies found' do
        run_test!
      end
    end
  end

  path '/movies/search' do
    get 'Retrieves a list of movies' do
      tags 'Movies'
      produces 'application/json'
      parameter name: 'q', required: true, in: :query, type: :string, description: 'Movie title'
      parameter name: 'page', in: :query, type: :integer, description: 'Page number', required: false

      response '200', 'movies found' do
        run_test!
      end
    end
  end

  path '/movies/{id}' do
    get 'Retrieves a movie' do
      tags 'Movies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'movie found' do
        let(:id) { 10_479 }
        run_test!
      end
    end
  end

  # Votes
  path '/movies/{id}/upvote' do
    put 'Upvotes a movie' do
      tags 'Movies'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'movie upvoted' do
        let(:id) { 10_479 }
        run_test!
      end
    end
  end

  path '/movies/{id}/downvote' do
    put 'Downvotes a movie' do
      tags 'Movies'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'movie downvoted' do
        let(:id) { 10_479 }
        run_test!
      end
    end
  end

  path '/movies/{id}/unvote' do
    delete 'Unvotes a movie' do
      tags 'Movies'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'movie downvoted' do
        let(:id) { 10_479 }
        run_test!
      end
    end
  end

  path '/movies/{id}/track' do
    put 'Tracks a movie progression' do
      tags 'Movies'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'movie tracked' do
        let(:id) { 10_479 }
        run_test!
      end
    end
  end
end