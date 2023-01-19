require 'cgi'
require 'async'

class TheMovieDbClient

  def initialize
    @api_url = Rails.configuration.film_api_url
    @api_version = Rails.configuration.film_api_version
    @api_key = ENV['THE_MOVIE_DB_API_3_KEY']
  end

  def by_id(type,id)

    raise ArgumentError.new("Invalid content type: #{type}") unless authorized_type?(type)

    language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    query = "#{@api_url}/#{@api_version}/#{type}/#{id}?api_key=#{@api_key}&language=#{language}"
    
    send(query)
  end

  def by_title(type,title,page=1)

    raise ArgumentError.new("Invalid content type: #{type}") unless authorized_type?(type)

    language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    title = CGI.escape(title)

    query = "#{@api_url}/#{@api_version}/search/#{type}?api_key=#{@api_key}&language=#{language}&query=#{title}&page=#{page}"

    Rails.logger.info query

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
      raise StandardError.new("Error with provider API")
    end
  end

  def authorized_type?(type)
    ['movie','tv'].include?(type)
  end
end