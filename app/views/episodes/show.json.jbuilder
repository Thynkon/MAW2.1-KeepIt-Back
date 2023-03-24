json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @episode["id"]
    json.episode_number @episode["episode_number"]
    json.season_number @episode["season_number"]
    json.name @episode["name"]
    json.overview @episode["overview"]
    json.air_date @episode["air_date"]
    json.still_path @episode["still_path"]
    json.guest_stars @episode["guest_stars"]
    json.crew @episode["crew"]
    json.runtime @episode["runtime"]
    json.production_code @episode["production_code"]
    json.vote_average @episode["vote_average"]
    json.vote_count @episode["vote_count"]

    if @user 
      json.user_time @user_watches_episode ? @user_watches_episode.time : 0
    end
  end
end