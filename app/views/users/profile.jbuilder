json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @user.id
    json.username @user.username
    json.email @user.email
    json.friends @user.friends
  end
end
