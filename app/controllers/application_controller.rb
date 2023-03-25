class ApplicationController < ActionController::API
  include Pundit::Authorization

  protected
  def authenticate
    rodauth.require_account # redirect to login page if not authenticated
  end

  def current_user
    rodauth.rails_account
  end
end
