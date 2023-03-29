json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @show["id"]
    json.name @show["name"]
    json.overview @show["overview"]
    json.tagline @show["tagline"]
    json.adult @show["adult"]
    json.backdrop_path @show["backdrop_path"]
    json.created_by @show["created_by"]
    json.episode_run_time @show["episode_run_time"]
    json.first_air_date @show["first_air_date"]
    json.genres @show["genres"]
    json.homepage @show["homepage"]
    json.in_production @show["in_production"]
    json.languages @show["languages"]
    json.last_air_date @show["last_air_date"]
    json.last_episode_to_air @show["last_episode_to_air"]
    json.next_episode_to_air @show["next_episode_to_air"]
    json.networks @show["networks"]
    json.number_of_episodes @show["number_of_episodes"]
    json.number_of_seasons @show["number_of_seasons"]
    json.origin_country @show["origin_country"]
    json.original_language @show["original_language"]
    json.original_name @show["original_name"]
    json.popularity @show["popularity"]
    json.poster_path @show["poster_path"]
    json.production_companies @show["production_companies"]
    json.production_countries @show["production_countries"]
    json.seasons @show["seasons"]
    json.spoken_languages @show["spoken_languages"]
    json.status @show["status"]
    json.type @show["type"]
    json.vote_average @show["vote_average"]
    json.vote_count @show["vote_count"]

    if @user
      json.last_watched_episode @last_watched_episode ? @last_watched_episode : nil
      json.user_vote @user_votes_show ? @user_votes_show.vote : 0
    end
  end
end