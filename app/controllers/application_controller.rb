class ApplicationController < ActionController::API
  protected
  def authenticate
    rodauth.require_account # redirect to login page if not authenticated
  end

  def current_user
    rodauth.rails_account
  end
end
