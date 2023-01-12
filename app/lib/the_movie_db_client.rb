require 'cgi'

class TheMovieDbClient
  def by_id(id)
    url = Rails.configuration.film_api_url
    api_key = ENV['THE_MOVIE_DB_API_3_KEY']
    language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    response = HTTP.headers(:accept => "application/json")
    .get("#{url}/3/movie/#{id}?api_key=#{api_key}&language=#{language}")

    if response.status.success?
      film = JSON.parse(response.body)

      return film
    else
      raise StandardError.new("Something went wrong")
    end
  end

  def by_title(title,page=1)
    url = Rails.configuration.film_api_url
    api_key = ENV['THE_MOVIE_DB_API_3_KEY']
    language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    title = CGI.escape(title)

    response = HTTP.headers(:accept => "application/json")
    .get("#{url}/3/search/movie?api_key=#{api_key}&language=#{language}&query=#{title}&page=#{page}")

    if response.status.success?
      films = JSON.parse(response.body)
      return films
    else
      raise StandardError.new("Something went wrong")
    end
  end
end