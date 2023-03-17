# Design choices

## Naming conventions

As this project is written in Ruby, the naming convention is defined [here](https://namingconvention.org/ruby/).

## Branch management

This project uses the [Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) approach to handle collaboration.

The `main` branch is protected from commits and merges. This branch only contains code that is being run in production. The `develop` branch is where the development of this project happens Each time someone wants to add a new feature, a new branch (feature) has to be created. Once the feature is finished, the code is then merged to `develop`.

Note that the code in `develop` is meant to be deployed in production at anytime.

## Technologies

### Authentication

Just like everyone who creates a Ruby on Rails application that requires some sort of authentication, we decided to use [devise](https://github.com/heartcombo/devise).

Initially, we thought that it would be the perfect solution as it supports the [JWT](https://jwt.io/) standard. But after encoutering [a bug regarding the JWT gem](https://github.com/waiting-for-dev/devise-jwt/issues/235#issuecomment-1214414894), we were stuck.

After spending some time looking for any kind of tutorial or documentaiton, we found [this article](https://dakotaleemartinez.com/tutorials/devise-jwt-api-only-mode-for-authentication/#sanity-check-try-it-out-in-postman) that explains how to implement a Ruby on Rails API using JWT.

The person who wrote the article has also encountered the same problem as me. Even though the solution suggested by the author worked, it was a work arround. We felt that such solution would make the reliability of our problem questionable.

For this reason we chose [Rodauth](https://rodauth.jeremyevans.net/), an authentication framework made by the same author as [Roda](https://roda.jeremyevans.net/) and [Sequel](https://sequel.jeremyevans.net/).

Note that `Rodauth` uses `Sequel` instead of `ActiveRecord`. A detailed explanation written by the person who created the integration gem regarding the reason why the Ruby on Rails integration gem still uses `Sequel` instead of `ActiveRecord` can be found [here](https://janko.io/what-it-took-to-build-a-rails-integration-for-rodauth/#active-record).

## Books API

We use Google's Book api as our data source of books. Even though it is the most popular books api, we still have found some problems.

### Book not found

If a book exists, the Google's Book api returns a `200` status code along with the books details.

```sh
curl -vvv -L 'https://www.googleapis.com/books/v1/volumes/hO33LPmTQGoC?key=<YOUR_API_KEY>'

# Response
< HTTP/2 200
< content-type: application/json; charset=UTF-8
< vary: X-Origin
< vary: Referer
< vary: Origin,Accept-Encoding
< date: Fri, 03 Mar 2023 07:54:05 GMT
< server: ESF
<
{
  "kind": "books#volume",
  "id": "hO33LPmTQGoC",
  "etag": "koOgLW5JeDA",
  "selfLink": "https://www.googleapis.com/books/v1/volumes/hO33LPmTQGoC",
  "volumeInfo": {
    "title": "Arsène Lupin, Gentleman-Thief",
    ...
  }
}
```

But when you try to fetch information about a book that does not exist, Google's API returns a `503` status code.

```sh
curl -vvv -L 'https://www.googleapis.com/books/v1/volumes/NON_EXISTING_ID?key=<YOUR_API_KEY>'

# Response
< HTTP/2 503
< vary: X-Origin
< vary: Referer
< vary: Origin,Accept-Encoding
< content-type: application/json; charset=UTF-8
< date: Fri, 03 Mar 2023 08:00:33 GMT
< server: ESF
< accept-ranges: none
<
{
  "error": {
    "code": 503,
    "message": "Service temporarily unavailable.",
    "errors": [
      {
        "message": "Service temporarily unavailable.",
        "domain": "global",
        "reason": "backendFailed"
      }
    ]
  }
}
```

Thus, we cannot know wether it is a `real network problem` or `the book does not exist`.

### Books without cover and description

By default, Google's books api returns any kind of book. By setting a param in the query string, we can filter by its subject, author, etc...

However, we cannot filter by some properties such as the cover and description. We have read [Google's official documentation](https://developers.google.com/books/docs/v1/using), but we still did not find a way to perform advanced filters.

Thus, we had to implement a [Chain of Responsability](https://refactoring.guru/design-patterns/chain-of-responsibility) that removes any book that is not interesting to us.

The source code can be found under `app/lib/books`. The chain of responsability mentioned above is currently used by the `GoogleBooksApiClient`.

#### Filter algorithm

![Filter algorithm](./diagrams/filter_algorithm.png)

In the image above, we can see how th filter algorithm works. It first tries to fetch 10 books that corresponds to a specific filter.

If, from the 10 books fetched, we have less than 10 books that corresponds to the filter, we fetch more books until we have a full list of books.

#### Search books by title

Even though Google books api allows us to [search books by a specific parameter](https://developers.google.com/books/docs/v1/using#PerformingSearch),
sometimes it may return books that do not match the search query.

For example, if we search for `The Lord of the Rings`, we may get books that are not related to the `Lord of the Rings` series.
We didn't find a reason for this behavior. We think that this might be due to the fact that sometimes the amount of available
books that match the search query is not enough. Thus, Google's api still tries to return the exact amount of books that we asked.

This has an impact on our unit tests as well as on the user experience.

## Serialization

By default, all attributes of any class are part of the serialized output when trying to render a view.

For example, the `/users` route returns all the users we have in our database.

We didn't want the password hash to be part of the output so we had to find a way to set the `serializable attributes` of a Model.

Ruby on Rails [ActiveModelSerialization](https://apidock.com/rails/ActiveModel/Serialization) class defines a method called [serializable_hash](https://apidock.com/rails/ActiveModel/Serialization/serializable_hash) that allows us to define the attributes we want to serialize.

But if you take a look at the examples, we can only specify the attributes we want to serialize when explicitly serializing a model.

This is not what we want. We want to be able to define the attributes we want to serialize for a given model. So we don't have to specify those attributes every time we want to render a view.

Thus, we overrode the `serializable_hash` method of the `ActiveModel::Serialization` class. If you want to use this feature, all you have to do is to set the `serializable_attributes` class attribute like this:

```ruby
class User < ApplicationRecord
  include Rodauth::Rails.model

  self.serializable_fields = [:username, :email]
end
```