class InvitationsController < ApplicationController
  before_action :authenticate, only: [:invitations, :invite]
  rescue_from Pundit::NotAuthorizedError, with: :handle_authorization_error

  # GET /users/{id}/invitations
  def index
    @user = User.find(params[:id])
    @invitations = @user.invitations
  end

  # POST /users/{id}/invite
  def create
    @user = current_user
    @friend = User.find(params[:id])

    # Since the send_invitation creates a new entry, we create a new instance of the model
    # in order to check permissions using the corresponding policy
    @invitation = UserHasFriend.new(user_id: @user.id, friend_id: @friend.id)
    authorize @invitation

    @invitation = @user.send_invitation(@friend)
  end

  # POST /invitations/{id}/accept
  def accept
    @user = current_user
    @invitation = UserHasFriend.find(params[:id])

    authorize @invitation

    @user.accept_invitation(@invitation)
  end

  # DELETE /invitations/{id}
  def destroy
    @user = current_user
    @invitation = UserHasFriend.find(params[:id])

    authorize @invitation
    @user.deny_invitation(@invitation)
  end

  protected
  def handle_authorization_error(exception)
    render "errors/error", format: :json, locals: { exception: exception, code: 403}, status: :forbidden
  end
end