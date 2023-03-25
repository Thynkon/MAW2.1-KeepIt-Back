json.apiVersion Rails.configuration.api_version

json.data do
  json.updated Time.now.utc.iso8601
  json.item do
    json.id @user.id
    json.email @user.email
    json.username @user.username

    if @current_user.friend?(@user)
      json.is_friend true
    else
      if @received_invitation != nil
        json.received_invitation do
          json.id @received_invitation.id
          json.created_at @received_invitation.created_at
        end
      end

      if @sent_invitation != nil
        json.sent_invitation do
          json.id @sent_invitation.id
          json.created_at @sent_invitation.created_at
        end
      end
    end
  end
end
