class InvitationsController < ApplicationController
  before_action :authenticate, only: [:invitations, :invite]

  # GET /users/{id}/invitations
  def index
      @user = User.find(params[:id])
      @invitations = @user.invitations
  end

  # POST /users/{id}/invite
  def invite
      @user = current_user
      @friend = User.find(params[:id])

      @user.send_invitation(@friend)
  end

  # POST /invitations/{invitation_id}/accept
  def accept
      @user = current_user
      @invitation = UserHasFriend.find(params[:id])
      
      if @user == @invitation.friend
          @user.accept_invitation(@invitation)
      else
          handle_authorization_error
      end
  end

  protected
  def handle_authorization_error
    render "errors/error", format: :json, locals: { exception: 'You are not authorized to access this resource', code: 403}, status: :forbidden
  end
end