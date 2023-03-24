require 'cgi'
require 'async'

class TheMovieDbClient

  def initialize
    @images_url = Rails.configuration.film_images_url
    @query_builder = TheMovieDbQueryBuilder.new
  end

  def popular(type:,page:1)

    query = @query_builder
                  .popular
                  .type(type: type)
                  .where(key: :page, value: page)
                  .build

    response = send(query)

    fetch_response(JSON.parse(response.body))
  end

  def by_id(type:,id:)

    query = @query_builder
                  .type(type: type)
                  .where(key: :id, value: id)
                  .build
    
    response = send(query)

    unless response.status.success?
        raise StandardError.new("Element not found") if response.status.code == 404
    end

    parsed_response = JSON.parse(response.body)

    add_image_url(parsed_response)
  end

  def by_title(type:,title:,page:1)

    title = CGI.escape(title)

    query = @query_builder
                  .search_mode
                  .type(type: type)
                  .where(key: :title, value: title)
                  .where(key: :page, value: page)
                  .build

    response = send(query)

    unless response.status.success?
        raise StandardError.new("Element not found") if response.status.code == 404
    end

    fetch_response(JSON.parse(response.body))
  end

  def season_by_number(show_id:,season_id:)

    query = @query_builder
                  .type(type: :tv)
                  .where(key: :id, value: show_id)
                  .season(season_id)
                  .build

    response = send(query)

    unless response.status.success?
        raise StandardError.new("Show or season not found") if response.status.code == 404
    end

    parsed_response = JSON.parse(response.body)

    add_image_url(parsed_response)
  end

  def episode_by_number_in_season(show_id:, season_id:, episode_id:)

    query = @query_builder
                  .type(type: :tv)
                  .where(key: :id, value: show_id)
                  .season(season_id)
                  .episode(episode_id)
                  .build

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

    image_keys_sizes = {
      'poster_path' => 'w185',
      'backdrop_path' => 'w300',
      'profile_path' => 'w185',
      'still_path' => 'w185',
      'logo_path' => 'w185'
    }

    content.map { | value |
      if value.is_a?(Hash) || value.is_a?(Array) then
        add_image_url(value)
      else
        value
      end
    }
    
    if content.is_a?(Hash) then
      image_keys_sizes.each { |key, size|
        content[key] = "#{@images_url}/#{size}#{content[key]}" if content.key?(key) && content[key]
      }
    end
    
    content
  end

end