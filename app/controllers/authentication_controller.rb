class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request, only: [:authenticate]
 
    def authenticate
    @user = User.find_by_email(params[:email])
    puts @user
    puts '-----------------'
    if @user && @user.authenticate(params[:password])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
    end
end
