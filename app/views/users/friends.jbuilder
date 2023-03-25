json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.totalItems @user.friends.length
  json.items @user.friends.map do |friend|
    json.id friend.id
    json.username friend.username
    json.email friend.email
    json.friendship do
      json.id @user.friendship(friend).id
      json.created_at @user.friendship(friend).created_at
    end
  end
end
