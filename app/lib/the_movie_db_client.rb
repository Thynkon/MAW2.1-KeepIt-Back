require 'cgi'
require 'async'

class TheMovieDbClient

  def initialize
    @api_url = Rails.configuration.film_api_url
    @api_version = Rails.configuration.film_api_version
    @api_key = Rails.application.credentials.the_movie_db_api_3_key
    @language = language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now
  end

  def by_id(type:,id:)

    raise ArgumentError.new("Invalid content type: #{type}") unless authorized_type?(type)

    query = "#{@api_url}/#{@api_version}/#{type}/#{id}?api_key=#{@api_key}&language=#{@language}"
    
    response = send(query)

    unless response.status.success?
        raise StandardError.new("Element not found") if response.status.code == 404
    end

    JSON.parse(response.body)
  end

  def by_title(type:,title:,page:1)

    raise ArgumentError.new("Invalid content type: #{type}") unless authorized_type?(type)

    title = CGI.escape(title)

    query = "#{@api_url}/#{@api_version}/search/#{type}?api_key=#{@api_key}&language=#{@language}&query=#{title}&page=#{page}"

    response = send(query)

    unless response.status.success?
        raise StandardError.new("Element not found") if response.status.code == 404
    end

    fetch_response(JSON.parse(response.body))
  end

  def season_by_number(show_id:,season_number:)
    query = "#{@api_url}/#{@api_version}/tv/#{show_id}/season/#{season_number}?api_key=#{@api_key}&language=#{@language}"
    response = send(query)

    unless response.status.success?
        raise StandardError.new("Show or season not found") if response.status.code == 404
    end

    JSON.parse(response.body)
  end

  private

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

    unless response.status.success?
        raise StandardError.new("Error with provider API") if response.status.code == 500
        raise StandardError.new("Invalid api key") if response.status.code == 401
    end

      response
  end

  def authorized_type?(type)
    ['movie','tv'].include?(type)
  end
end