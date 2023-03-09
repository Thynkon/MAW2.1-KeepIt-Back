require 'cgi'
require 'async'

class TheMovieDbClient

  def initialize
    @api_url = Rails.configuration.film_api_url
    @api_version = Rails.configuration.film_api_version
    @api_key = Rails.application.credentials.the_movie_db_api_3_key
    @language = language = Rails.configuration.language # Could be replaced by i18n locales but in config file for now
    @images_url = Rails.configuration.film_images_url
  end

  def popular(type:,page:1)

    raise ArgumentError.new("Invalid content type: #{type}") unless authorized_type?(type)

    query = "#{@api_url}/#{@api_version}/#{type}/popular?api_key=#{@api_key}&language=#{@language}&page=#{page}"

    response = send(query)

    fetch_response(JSON.parse(response.body))
  end

  def by_id(type:,id:)

    raise ArgumentError.new("Invalid content type: #{type}") unless authorized_type?(type)

    query = "#{@api_url}/#{@api_version}/#{type}/#{id}?api_key=#{@api_key}&language=#{@language}"
    
    response = send(query)

    unless response.status.success?
        raise StandardError.new("Element not found") if response.status.code == 404
    end

    parsed_response = JSON.parse(response.body)

    add_image_url(parsed_response)
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

    parsed_response = JSON.parse(response.body)

    add_image_url(parsed_response)
  end

  def episode_by_number_in_season(show_id:, season_number:, episode_number:)
    query = "#{@api_url}/#{@api_version}/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}?api_key=#{@api_key}&language=#{@language}"
    response = send(query)

    unless response.status.success?
        raise StandardError.new("Show or season not found") if response.status.code == 404
    end

    parsed_response = JSON.parse(response.body)

    add_image_url(parsed_response)
  end

  private

  def fetch_response(response)

    response["results"] = response["results"].map { |content| add_image_url(content)}

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

  # The API returns only relative paths for images. This method adds the base url to the relative path
  #
  # Content can be trees of entities that can all have images. The tree is higly variable but names of keys that are image paths are always the same.
  # This method is recursive and will add the base url to all images found in the tree.
  def add_image_url(content)
    image_keys = ['poster_path','backdrop_path','profile_path','still_path','logo_path']

    content.map { | value |
      if value.is_a?(Hash) || value.is_a?(Array) then
        add_image_url(value)
      else
        value
      end
    }
    
    if content.is_a?(Hash) then
      image_keys.each { |key|
        content[key] = "#{@images_url}/original#{content[key]}" if content.key?(key) && content[key]
      } 
    end
    
    content
  end

  def authorized_type?(type)
    [:movie,:tv].include?(type)
  end
end