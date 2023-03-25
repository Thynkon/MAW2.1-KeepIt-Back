json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems @invitations.length
  json.items  @invitations.map do |invitation|
    json.id invitation[:id]
    json.author invitation.user
    json.sent_at invitation[:created_at]
  end
end
