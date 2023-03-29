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
          movie: {
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
                      imdb_id: { type: :string },
                      title: { type: :string },
                      original_title: { type: :string },
                      tagline: { type: :string },
                      adult: { type: :boolean },
                      backdrop_path: { type: :string },
                      budget: { type: :integer },
                      genres: { type: :array, items: { 
                        type: :object, 
                        properties: {
                          id: { type: :integer },
                          name: { type: :string }
                          }
                        },
                      },
                      homepage: { type: :string },
                      original_language: { type: :string },
                      overview: { type: :string },
                      popularity: { type: :number },
                      poster_path: { type: :string },
                      production_companies: { type: :array, items: {
                          type: :object,
                          properties: {
                            id: { type: :integer },
                            logo_path: { type: :string },
                            name: { type: :string },
                            origin_country: { type: :string }
                          }
                        }
                      },
                      production_countries: { type: :array, items: {
                        type: :object,
                        properties: {
                          iso_3166_1: { type: :string },
                          name: { type: :string }
                          }
                        },
                      },
                      release_date: { type: :string, format: 'date-time' },
                      revenue: { type: :integer },
                      runtime: { type: :integer },
                      spoken_languages: { type: :array, items: {
                        type: :object,
                        properties: {
                          english_name: { type: :string },
                          iso_639_1: { type: :string },
                          name: { type: :string }
                          }
                        }
                      },
                      status: { type: :string },
                      video: { type: :boolean },
                      vote_average: { type: :number },
                      vote_count: { type: :integer },
                      user_vote: { type: :integer },
                      user_time: { type: :integer }
                    }
                  }
                }
              }
            }
          },
          show: {
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
                      name: { type: :string },
                      overview: { type: :string },
                      tagline: { type: :string },
                      adult: { type: :boolean },
                      backdrop_path: { type: :string },
                      created_by: { type: :array, items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          credit_id: { type: :string },
                          name: { type: :string },
                          gender: { type: :integer },
                          profile_path: { type: :string }
                        }
                      }},
                      episode_run_time: { type: :array, items: { type: :integer }},
                      first_air_date: { type: :string, format: 'date-time' },
                      genres: { type: :array, items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          name: { type: :string }
                        }
                      }},
                      homepage: { type: :string },
                      in_production: { type: :boolean },
                      languages: { type: :array, items: { type: :string }},
                      last_air_date: { type: :string, format: 'date-time' },
                      last_episode_to_air: { type: :object, properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        overview: { type: :string },
                        vote_average: { type: :number },
                        vote_count: { type: :integer },
                        air_date: { type: :string, format: 'date-time' },
                        episode_number: { type: :integer },
                        season_number: { type: :integer },
                        show_id: { type: :integer },
                        still_path: { type: :string },
                      }},
                      next_episode_to_air: { type: :object, properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        overview: { type: :string },
                        vote_average: { type: :number },
                        vote_count: { type: :integer },
                        air_date: { type: :string, format: 'date-time' },
                        episode_number: { type: :integer },
                        season_number: { type: :integer },
                        show_id: { type: :integer },
                        still_path: { type: :string },
                        production_code: { type: :string },
                        runtime: { type: :integer },
                      }},
                      networks: { type: :array, items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          logo_path: { type: :string },
                          origin_country: { type: :string }
                        }
                      }},
                      number_of_episodes: { type: :integer },
                      number_of_seasons: { type: :integer },
                      origin_country: { type: :array, items: { type: :string }},
                      original_language: { type: :string },
                      original_name: { type: :string },
                      popularity: { type: :number },
                      poster_path: { type: :string },
                      production_companies: { type: :array, items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          logo_path: { type: :string },
                          name: { type: :string },
                          origin_country: { type: :string }
                        }
                      }},
                      production_countries: { type: :array, items: {
                        type: :object,
                        properties: {
                          iso_3166_1: { type: :string },
                          name: { type: :string }
                        }
                      }},
                      seasons: { type: :array, items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          name: { type: :string },
                          overview: { type: :string },
                          air_date: { type: :string, format: 'date-time' },
                          episode_count: { type: :integer },
                          poster_path: { type: :string },
                          season_number: { type: :integer },
                        }
                      }},
                      status: { type: :string },
                      type: { type: :string },
                      vote_average: { type: :number },
                      vote_count: { type: :integer },
                      last_watched_episode: { type: :object, properties: {
                        id: { type: :integer },
                        time: { type: :integer },
                        user_id: { type: :integer },
                        show_id: { type: :integer },
                        season_id: { type: :integer },
                        episode_id: { type: :integer },
                        created_at: { type: :string, format: 'date-time' },
                        updated_at: { type: :string, format: 'date-time' },
                      }},
                      user_vote: { type: :integer },
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
          invitations: {
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
                        friend: { type: :object,
                          properties: {
                            id: { type: :integer },
                            email: { type: :string },
                            username: { type: :string },
                          }
                        },
                        sent_at: { type: :string, format: 'date-time' },
                      }
                    }
                  }
                }
              }
            },
          },
          friends: {
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
                        email: { type: :string },
                        username: { type: :string },
                      }
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
