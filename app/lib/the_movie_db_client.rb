require 'cgi'
require 'async'

class TheMovieDbClient
  def by_id(id)
    url = Rails.configuration.film_api_url
    api_key = ENV['THE_MOVIE_DB_API_3_KEY']
    language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    query = "#{url}/3/movie/#{id}?api_key=#{api_key}&language=#{language}"
    
    send(query)
  end

  def by_title(title,page=1)
    url = Rails.configuration.film_api_url
    api_key = ENV['THE_MOVIE_DB_API_3_KEY']
    language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    title = CGI.escape(title)

    query = "#{url}/3/search/movie?api_key=#{api_key}&language=#{language}&query=#{title}&page=#{page}"

    result = send(query)

    fetch_response(result)
  end

  def fetch_response(response)
      {
        page: response['page'],
        total_items: response["total_results"],
        total_pages: response["total_pages"],
        results: response["results"]
      }
  end

  def send(query)
    task = Async do
      HTTP.headers(:accept => "application/json")
          .get(query)
    end

    response = task.wait

    if response.status.success?
      return JSON.parse(response.body)
    else
      raise StandardError.new("Something went wrong")
    end
  end
end