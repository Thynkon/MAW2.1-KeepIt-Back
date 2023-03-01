class ApplicationController < ActionController::API
  after_action :set_jwt_token

  protected
  def authenticate
    rodauth.require_account # redirect to login page if not authenticated
  end

  def current_user
    rodauth.rails_account
  end

  # After reading Rodauth's source and documentation, I didn't find a way to
  # add custom data to the JWT token. So, I'm using th 'session_jwt' method (https://rodauth.jeremyevans.net/rdoc/files/doc/jwt_rdoc.html#label-Auth+Methods)
  def set_jwt_token
    # By default, the session_jwt method returns a JWT token with the following payload:
    # { "account_id" => X, "authenticated_by" => ["password"]}
    # Those values are required by Rodauth to validated the JWT
    #   From rodauth/features/base.rb
    #       session_key :session_key, :account_id
    #       session_key :authenticated_by_session_key, :authenticated_by
    # Thus, those values must be present in the JWT token.
    payload = JWT.decode(rodauth.session_jwt, Rails.application.secrets.secret_key_base, true, lgorithm: rodauth.jwt_algorithm)

    # When decoding the JWT token, the payload is an array of hashes. The first hash is the payload,
    # the second hash is the header. We want to delete the header from the payload.
    payload = payload.delete_if{|k| k.has_key?("alg")}.first
    payload["user"] = current_user.as_json(only: [:id, :email, :username])

    token = JWT.encode(payload, Rails.application.secrets.secret_key_base, rodauth.jwt_algorithm)

    response.headers["Authorization"] = token
  end
end
