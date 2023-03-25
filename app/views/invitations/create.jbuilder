json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @invitation.id
    json.created_at @invitation.created_at
  end
end