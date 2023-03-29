class UsersController < ApplicationController
    before_action :authenticate, only: [:update, :destroy]
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # GET /users
    def index
      @users = User.all
    end

    # GET /users/{id}
    def show
      @user = User.find(params[:id])
      @current_user = current_user

      if @current_user != nil && @current_user != @user
        @received_invitation = @user.invitation_from(@current_user)
        @sent_invitation = @current_user.invitation_from(@user)
      end
    end

    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        @current_user = current_user
        render :show
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/{id}
    def update
      @user = User.find(params[:id])
      authorize @user

      if @user.update(user_params)
        @current_user = current_user
        render :show
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/{id}
    def destroy
      @user = User.find(params[:id])
      authorize @user

      @user.destroy
      head :no_content
    end

    # GET /users/{id}/friends
    def friends
      @user = User.find(params[:id])
    end

    private
      def handle_http_error(exception)
        render "errors/error", format: :json, locals: { exception: exception, code: 401}, status: :unauthorized
      end

      def user_params
        params.permit(:username, :email, :firstname, :lastname, :password)
      end
end
