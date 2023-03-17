# Keet-it
<a name="readme-top"></a>
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
        <a href="#built-with">Built With</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#configuration">Configuration</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#tests">Tests</a></li>
    <li><a href="#documentation">Documentation</a></li>
    <li><a href="#conventions">Conventions</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

### Built With

* [Ruby][ruby-url]
* [Ruby on Rails][rails-url]
* [Http.rb][httprb-url]
* [Async-io][asyncio-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

This is the backend of a web application whose goal is to allow users to keep a track of books/movies they are reading/watching.

### Prerequisites

All you need to do is to install a Ruby version greater than `3.1.0`. One of the easiest ways to do it is by using [rvm](https://rvm.io/).

### Installation
#### On your machine

1. Install dependencies
   ```sh
   bundle
   ```

2. Create database and lanch migrations
   ```sh
   ./bin/rails db:migrate
   ```
3. Finally, launch the web server and the interactive shell
   ```sh
   ./bin/rails server
   ```

   Or you if want to have an interactive shell and execute Ruby code in live (just like `IRB`):
   
   ```sh
   ./bin/rails console
   ```

#### On a Docker container

If you take a look at the `Dockerfile`, you will notice that you can change the default `EDITOR` environment variable that is used to edit `Ruby on Rails` credentials files.

1. Change the `EDITOR` environment variable (**OPTIONAL**)

   ```yml
   build:
      context: .
      args:
        editor: "<YOUR_FAVOURITE_EDITOR>"
   ```

2. Build the Docker image
   ```sh
   docker compose build
   ```

3. Start the container
   ```sh
   docker compose up -d
   ```

4. Show container logs
   ```sh
   docker compose logs -f
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Configuration
#### Books API

As we use Google's Book API, you need to generate an API key for this project. [The official documentation](https://developers.google.com/books/docs/v1/using#APIKey) explains how to do it.

Once you have generated the API key, you must enable it. Go to [this link](https://console.cloud.google.com/apis/library/books.googleapis.com) and enable it.

Finally, add your API key to Rails credentials file:
```sh
./bin/rails credentials:edit
```

This command should open a temporary `yml` file. You can then add Google's Book API key:
```yml
google_books_api_key: <YOUR_API_KEY>
```

#### Movies and shows API

As we use TheMovieDb API, you also need to generate an API key for this project. [The official documentation](https://developers.themoviedb.org/3/getting-started/introduction) explains how to do it.

Once the key is generated, you can add it the same way as for books API.
Open the credentials file:
```sh
./bin/rails credentials:edit
```
And add the key at the end of it:
```yml
the_movie_db_api_3_key: <YOUR_API_KEY>
```

#### Docker environment

In order to be able to run the backend in a Docker container and perform requests from a frontend application, you need to enable and setup `CORS`.

Here is an example of `config/initializers/cors.rb`:
```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
 allow do
   origins "*"

   resource "*",
     headers: :any,
     methods: [:get, :post, :put, :patch, :delete, :options, :head]
 end
end
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Tests

In order to run all tests type:

```sh
bundle exec rspec
```

If you want to run all tests of a file
```sh
bundle exec rspec ./spec/<FILE_TEXT>_spec.rb
```

## Documentation

You can find class diagrams as well other kinds of diagrams under `doc/`.

Explanations about some researches we have done can also be found in `doc/`.

If you want a detailed documentation about the API, you can use the `swagger ui` that is available at `http://localhost:4000/api-docs`.

## Conventions

As we implement a REST API, we decided to use the same standard as Google.

The specifications are greatly explained [here](https://google.github.io/styleguide/jsoncstyleguide.xml?showone=YouTube_JSON_API#YouTube_JSON_API). Take a look at the `YouTube JSON API` section.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License
Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[ruby-url]: https://www.ruby-lang.org
[rails-url]: https://rubyonrails.org
[httprb-url]: https://github.com/httprb/http
[asyncio-url]: https://github.com/socketry/async
