require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do

  path '/login' do
    post 'Authenticate' do
      tags 'Login'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          login: { type: :string, example: 'admin@host.com' },
          password: { type: :string },
        }
      }

      response '200', 'sucessfully authenticated' do
        run_test!
        schema '$ref' => '#/components/schemas/login_success'
      end

      response '401', 'authentication failed' do
        run_test!
        schema '$ref' => '#/components/schemas/auth_error'
      end
    end
  end

  path '/register' do
    post 'Create a new account' do
      tags 'Register'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :register, in: :body, schema: {
        type: :object,
        properties: {
          login: { type: :string, example: 'admin@host.com' },
          password: { type: :string },
          'password-confirm': { type: :string },
        }
      }

      response '200', 'sucessfully authenticated' do
        run_test!
        schema '$ref' => '#/components/schemas/register_success'
      end

      response '422', 'authentication failed' do
        run_test!
        schema '$ref' => '#/components/schemas/auth_error'
      end
    end
  end

  path '/jwt-refresh' do
    post 'Refresh authentication token' do
      tags 'Refresh token'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :jwt_refresh, in: :body, schema: {
        type: :object,
        properties: {
          refresh_token: { type: :string },
        }
      }

      response '200', 'sucessfully authenticated' do
        run_test!
        schema '$ref' => '#/components/schemas/register_success'
      end

      response '422', 'authentication failed' do
        run_test!
        schema '$ref' => '#/components/schemas/auth_error'
      end
    end
  end

end