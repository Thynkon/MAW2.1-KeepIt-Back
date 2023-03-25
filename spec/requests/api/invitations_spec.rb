require 'swagger_helper'

RSpec.describe 'Invitations', type: :request do

  path '/users/{id}/invitations' do
    get 'Retrieves a list of invitations' do
      tags 'Invitations'
      security [Bearer: {}]
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'invitations found' do
        run_test!
        schema '$ref' => '#/components/schemas/invitations'
      end
    end
  end

  path '/users/{id}/friends' do
    get 'Retrieves a list of friends' do
      tags 'Invitations'
      security [Bearer: {}]
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'friends found' do
        run_test!
        schema '$ref' => '#/components/schemas/friends'
      end
    end
  end

  path '/users/{id}/invite' do
    post 'Invites a friend' do
      tags 'Invitations'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '204', 'invitation sent' do
        run_test!
      end
    end
  end

  path '/invitation/{id}/accept' do
    put 'Accepts an invitation' do
      tags 'Invitations'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '204', 'invitation sent' do
        run_test!
      end
    end
  end

  path '/invitation/{id}' do
    delete 'Denies an invitation' do
      tags 'Invitations'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '204', 'invitation denied' do
        run_test!
      end
    end
  end
end