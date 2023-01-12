# API technical documentation
## API Type
Initially, we thought that GraphQL would be the most appropriate type of API as it was used by Facebook to fetch data from multiple data sources. However, after a discussion we found out that what we really needed was to group multiple data sources together and, for that, a 'simple' REST API meets our requirements.

### GraphQL
Even thought we are not going to implement a GraphQL API, here's what we have discovered during our research.

#### The Schema Definition Language (SDL)
You need to define GraphQL's schema
- Root Types
    - Query
        - If you want to access a resource/expose an API that fetches data, all you need to do is to define a query type.
            ``` graphql
            type Query {
                post(id:): [Post!]!
            }
            ```
            Where `post(id:)`is an 'alias'/'mapped' name to an actual function (Ruby, Python, etc...)

            In `Ruby`, here's how it would be implemented:
            ``` ruby
            module Types
                class QueryType < Types::BaseObject
                    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
                    include GraphQL::Types::Relay::HasNodeField
                    include GraphQL::Types::Relay::HasNodesField

                    # Add root-level fields here.
                    # They will be entry points for queries on your schema.
                    #
                    # First describe the field signature:
                    field :post, PostType, "Find a post by ID" do
                    argument :id, ID
                    end

                    # Then provide an implementation:
                    def post(id:)
                        Post.find(id)
                    end
                end
            end
            ```
            Notice that `post(id:)` can return anything as well as call any kind of code. In this case it called an `ActiveRecord` model but it could have called a REST API.

    - Mutation

      **creating** new data
      ``` ruby
      class Types::MutationType < GraphQL::Schema::Object
          field :create_post, mutation: Mutations::AddPost
      end
      ```

      **updating** existing data

      **deleting** existing data
    - Subscription
        - Just like websocket, users can subscribe to channels and get real-time updated data
          ``` ruby
          class Types::SubscriptionType < GraphQL::Schema::Object
            field :comment_added, subscription: Subscriptions::CommentAdded
          end
          ```


``` graphql
type Posts {
  id: Int!
  title: String!
}
```

Or in `Ruby`

``` ruby
  module Types
    class PostType < Types::BaseObject
      description "A blog post"
      field :id, ID, null: false
      field :title, String, null: false
      # fields should be queried in camel-case (this will be `truncatedPreview`)
      field :truncated_preview, String, null: false
      # Fields can return lists of other objects:
    end
  end
```

# Resources
- [How to GraphQL - Core Concepts](https://www.howtographql.com/basics/2-core-concepts/)
- [GraphQL Ruby - Getting started](https://graphql-ruby.org/getting_started)
- [GraphQL Ruby - Root Types](https://graphql-ruby.org/schema/root_types.html)