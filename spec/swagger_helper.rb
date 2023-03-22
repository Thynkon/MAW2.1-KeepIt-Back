# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      components: {
        schemas: {
          books: {
            type: 'object',
            properties: {
              apiVersion: { type: :string },
              data: {
                type: :object,
                properties: {
                  updated: { type: :string, format: 'date-time' },
                  totalItems: { type: :integer },
                  items: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        cover: { type: :string },
                        published_at: { type: :string, format: 'date-time' },
                        upvotes: { type: :integer },
                        downvotes: { type: :integer }
                      }
                    }
                  }
                }
              }
            },
          },
          book: {
            type: 'object',
            properties: {
              apiVersion: { type: :string },
              data: {
                type: :object,
                properties: {
                  updated: { type: :string, format: 'date-time' },
                  item: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      title: { type: :string },
                      cover: { type: :string },
                      published_at: { type: :string, format: 'date-time' },
                      upvotes: { type: :integer },
                      downvotes: { type: :integer }
                    }
                  }
                }
              }
            },
          },
          achievements: {
            type: 'object',
            properties: {
              apiVersion: { type: :string },
              data: {
                type: :object,
                properties: {
                  updated: { type: :string, format: 'date-time' },
                  totalItems: { type: :integer },
                  items: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        description: { type: :string },
                        percentage: { type: :integer },
                        created_at: { type: :string, format: 'date-time' },
                      }
                    }
                  }
                }
              }
            },
          },
          achievement: {
            type: 'object',
            properties: {
              apiVersion: { type: :string },
              data: {
                type: :object,
                properties: {
                  updated: { type: :string, format: 'date-time' },
                  item: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      title: { type: :string },
                      description: { type: :string },
                      percentage: { type: :integer },
                      created_at: { type: :string, format: 'date-time' },
                    }
                  }
                }
              }
            },
          },
          login_success: {
            type: :object,
            properties: {
              access_token: { type: :string },
              refresh_token: { type: :string },
              success: { type: :string },
            },
          },
          auth_error: {
            type: :object,
            properties: {
              'field-error': {
                type: :array,
                items: [
                  type: :string
                ]
              },
              error: { type: :string },
            },
          },
          register_success: {
            type: :object,
            properties: {
              access_token: { type: :string },
              refresh_token: { type: :string },
              success: { type: :string },
            },
          },
        }
      },
      securitySchemes: {
        Bearer: {
          description: 'JWT key necessary to use API calls',
          type: :http,
          scheme: :bearer,
          bearerFormat: 'JWT',
          name: 'authorization',
          in: :header
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:4000'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
