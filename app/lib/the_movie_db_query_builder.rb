class TheMovieDbQueryBuilder
  VALID_WHERE = {id: :id,title: :query,langage: :langage, page: :page}
  VALID_TYPE = {tv: :tv,movie: :movie}

  def initialize
    @query_params = {}
    @url_params = {}

    @url_params[:url] = Rails.configuration.film_api_url
    @url_params[:api_version] = Rails.configuration.film_api_version
    @query_params[:api_key] = Rails.application.credentials.the_movie_db_api_3_key
    @query_params[:langage] = Rails.configuration.language # Could be replaced by i18n locales but in config file for now

    @url_params[:search_mode] = false
    @url_params[:popular_mode] = false
    
  end

  def where(key:, value:)
    raise ArgumentError, "Invalid where key: #{key}" unless VALID_WHERE.key?(key)

    if value == nil
      @query_params.delete VALID_WHERE[key]
      return self
    end
    
    if key == :id
      @url_params[:id] = value
    else
      @query_params[VALID_WHERE[key]] = value
    end
    self
  end

  def search_mode(enabled=true)
    @url_params[:search_mode] = enabled
    self
  end

  def popular(enabled=true)
    @url_params[:popular_mode] = enabled
    self
  end

  def type(type:)
    raise ArgumentError, "Invalid type: #{type}" unless VALID_TYPE.key?(type)

    @url_params[:type] = type
    self
  end

  def season(season)
    @url_params[:season] = season
    self
  end

  def episode(episode)
    @url_params[:episode] = episode
    self
  end

  # Check the validity of the builder parameters. 
  #
  # Will return true if valid and rise exception otherwise
  def valid?
    raise BuilderMissingParameterError.new "Missing type parameter." unless @url_params.key?(:type)

    
    # In the case below, Object matches everything
    case [@url_params[:search_mode], @url_params[:popular_mode], @url_params[:id], @query_params[:query], @url_params[:season], @url_params[:episode]]
      in [true, true,Object,Object,Object,Object]
        raise BuilderArgumentError.new "popular and search mode enabled at the same time"
      in [Object,Object,String, String,Object,Object]
        raise BuilderArgumentError.new "id and title set at the same"
      in [true, false,Object, nil,Object,Object]
        raise BuilderMissingParameterError.new "Missing title parameter in search mode"
      in [true, false, String,Object,Object,Object]
        raise BuilderArgumentError.new "id set in search mode"
      in [false, false, nil,Object,Object,Object]
        raise BuilderArgumentError.new "Not all required parameters were given"
      in [false, true, String,Object,Object,Object]
        raise BuilderArgumentError.new "id set in popular mode"
      in [false,Object,Object,String,Object,Object]
        raise BuilderArgumentError.new "Title search outside of search mode"
      in [true,false,Object,Object,String,String]
        raise BuilderArgumentError.new "Season or episode set in search mode"
      in [false,true,Object,Object,String,String]
        raise BuilderArgumentError.new "Season or episode set in popular mode"
      in [Object,Object,nil,Object,String,Object]
        raise BuilderMissingParameterError.new "Season set whithout content id"
      in [Object,Object,Object,Object,nil,String]
        raise BuilderMissingParameterError.new "Episode set whithout season"
      else
        true
    end

    true
  end

  def build
    valid? # will rise an exception if not valid

    query_string = @query_params.map { |k, v| "#{k}=#{v}" }.join('&')

    url_items = []
    url_items << @url_params[:url]
    url_items << @url_params[:api_version]
    url_items << "search" if @url_params[:search_mode]
    url_items << @url_params[:type]
    url_items << "popular" if @url_params[:popular_mode]
    url_items << @url_params[:id]
    url_items << "season" if @url_params[:season]
    url_items << @url_params[:season]
    url_items << "episode" if @url_params[:episode]
    url_items << @url_params[:episode]

    url_string = url_items.compact.join("/")
    
    query = "#{url_string}?#{query_string}"
    
  end
end