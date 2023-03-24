json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  
  json.item do
    json.id @movie["id"]
    json.imdb_id @movie["imdb_id"]
    json.title @movie["title"]
    json.original_title @movie["original_title"]
    json.tagline @movie["tagline"]
    json.adult @movie["adult"]
    json.backdrop_path @movie["backdrop_path"]
    json.belongs_to_collection @movie["belongs_to_collection"]
    json.budget @movie["budget"]
    json.genres @movie["genres"]
    json.homepage @movie["homepage"]
    json.original_language @movie["original_language"]
    json.overview @movie["overview"]
    json.popularity @movie["popularity"]
    json.poster_path @movie["poster_path"]
    json.production_companies @movie["production_companies"]
    json.production_countries @movie["production_countries"]
    json.release_date @movie["release_date"]
    json.revenue @movie["revenue"]
    json.runtime @movie["runtime"]
    json.spoken_languages @movie["spoken_languages"]
    json.status @movie["status"]
    json.video @movie["video"]
    json.vote_average @movie["vote_average"]
    json.vote_count @movie["vote_count"]

    if @user 
      json.user_vote @user_votes_movie ? @user_votes_movie.vote : 0
      json.user_time @user_watches_movie ? @user_watches_movie.time : 0
    end
  end
end