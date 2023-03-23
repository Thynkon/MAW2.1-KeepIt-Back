json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems @user.friends.length
  json.items @user.friends
end
