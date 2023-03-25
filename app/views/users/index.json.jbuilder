json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems @users.length
  json.items  @users.map do |user|
    json.id user.id
    json.email user.email
    json.username user.username
  end
end
