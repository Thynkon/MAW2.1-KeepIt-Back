class UsersController < ApplicationController
    before_action :authenticate, only: [:update, :destroy, :friends]
    before_action :check_user, only: [:update, :destroy]

    # GET /users
    def index
        @users = User.all
        render json: @users, status: :ok
    end
    
    # GET /users/username
    def show
        @user = User.find(params[:id])
        render json: @user, status: :ok
    end

    # POST /users
    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /users/1
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            render json: @user, status: :ok
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    # DELETE /users/1
    def destroy
        @user.destroy
        head :no_content
    end

    # GET /users/{id}/friends
    def friends
        @user = User.find(params[:id])
    end

    private
        def check_user
            if current_user.id.to_s != params[:id].to_s
                render json: { errors: 'You are not authorized to access this resource' }, status: :unauthorized
            end
        end

        def user_params
            params.permit(:username, :email, :firstname, :lastname, :password)
        end
end
