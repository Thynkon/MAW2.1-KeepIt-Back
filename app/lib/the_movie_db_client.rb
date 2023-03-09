require 'cgi'
require 'async'

class TheMovieDbClient

  def initialize
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

    JSON.parse(response.body)
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

  def season_by_number(show_id:,season_number:)

    query = @query_builder
                  .type(type: :tv)
                  .where(key: :id, value: show_id)
                  .season(season_number)
                  .build

    response = send(query)

    unless response.status.success?
        raise StandardError.new("Show or season not found") if response.status.code == 404
    end

    JSON.parse(response.body)
  end

  def episode_by_number_in_season(show_id:, season_number:, episode_number:)

    query = @query_builder
                  .type(type: :tv)
                  .where(key: :id, value: show_id)
                  .season(season_number)
                  .episode(episode_number)
                  .build

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
end