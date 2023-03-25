json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @user.id
    json.email @user.email
    json.username @user.username
    json.has_requested_friendship @user.has_invited?(@current_user)
    json.has_received_invitation @current_user.has_invited?(@user)
  end
end
