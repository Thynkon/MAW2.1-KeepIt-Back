class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that are loaded.
    enable :create_account,
           :login, :logout, :json, :jwt, :jwt_refresh,
           :reset_password, :change_password, :change_password_notify,
           :change_login, :verify_login_change, :close_account

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "b5154a73b98f5ac56999cd558478cb4a2e9c3ed1912d4cf348c359c3c048c768cef51aaf1bbd9c3414b02754cb9d040b0dc18c26d86d6d8b488d5cc1e6011c3f"

    # ==> Account
    before_create_account do
      # Validate presence of the name field
      unless username = param_or_nil("username")
        throw_error_status(422, "username", "must be present")
      end

      # Assign the new field to the account record
      account[:username] = username
    end

    # Set JWT secret, which is used to cryptographically protect the token.
    jwt_secret Rails.application.secrets.secret_key_base

    jwt_refresh_token_table :user_jwt_refresh_keys
    jwt_refresh_token_account_id_column :user_id
    # Default expiration time is 1 day
    jwt_access_token_period 3600 * 24

    # After reading Rodauth's source and documentation, I didn't find a way to
    # add custom data to the JWT token. So, I'm using the 'session_jwt' method (https://rodauth.jeremyevans.net/rdoc/files/doc/jwt_rdoc.html#label-Auth+Methods)
    set_jwt_token do |token|
      # By default, the session_jwt method returns a JWT token with the following payload:
      # { "account_id" => X, "authenticated_by" => ["password"]}
      # Those values are required by Rodauth to validated the JWT
      #   From rodauth/features/base.rb
      #       session_key :session_key, :account_id
      #       session_key :authenticated_by_session_key, :authenticated_by
      # Thus, those values must be present in the JWT token.
      payload = JWT.decode(session_jwt, Rails.application.secrets.secret_key_base, true, algorithm: jwt_algorithm)

      # When decoding the JWT token, the payload is an array of hashes. The first hash is the payload,
      # the second hash is the header. We want to delete the header from the payload.
      payload = payload.delete_if { |k| k.has_key?("alg") }.first
      payload["user"] = rails_account.as_json(only: [:id, :email, :username])

      token = JWT.encode(payload, Rails.application.secrets.secret_key_base, jwt_algorithm)
      if authenticated?
        json_response[jwt_access_token_key] = token
      end
    end

    # Accept only JSON requests.
    only_json? true

    # Change redirect when login is required to "/signin"
    require_login_redirect { login_path }

    # Change create account route to "/register"
    create_account_route "register"

    # Handle login and password confirmation fields on the client side.
    # require_password_confirmation? false
    # require_login_confirmation? false

    # Specify the controller used for view rendering and CSRF verification.
    rails_controller { RodauthController }

    # Set on Rodauth controller with the title of the current page.
    title_instance_variable :@page_title

    # Default table is 'accounts', change it to 'users'.
    accounts_table :users

    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    account_password_hash_column :password_hash

    # Passwords shorter than 8 characters are considered weak according to OWASP.
    password_minimum_length 8
    # bcrypt has a maximum input length of 72 bytes, truncating any extra bytes.
    password_maximum_bytes 72

    # Set password when creating account instead of when verifying.
    # verify_account_set_password? false

    # Redirect back to originally requested location after authentication.
    # login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    # reset_password_autologin? true

    # Delete the account record when the user has closed their account.
    # delete_account_on_close? true

    reset_password_table :user_password_reset_keys
    verify_login_change_table :user_login_change_keys
    verify_login_change_table :user_login_change_keys

    # Redirect to the app from login and registration pages if already logged in.
    # already_logged_in { redirect login_redirect }

    # ==> Emails
    # Use a custom mailer for delivering authentication emails.
    create_reset_password_email do
      RodauthMailer.reset_password(self.class.configuration_name, account_id, reset_password_key_value)
    end
    # create_verify_account_email do
    #  RodauthMailer.verify_account(self.class.configuration_name, account_id, verify_account_key_value)
    # end
    # create_verify_login_change_email do |_login|
    #  RodauthMailer.verify_login_change(self.class.configuration_name, account_id, verify_login_change_key_value)
    # end
    create_password_changed_email do
      RodauthMailer.password_changed(self.class.configuration_name, account_id)
    end
    # create_reset_password_notify_email do
    #   RodauthMailer.reset_password_notify(self.class.configuration_name, account_id)
    # end
    # create_email_auth_email do
    #   RodauthMailer.email_auth(self.class.configuration_name, account_id, email_auth_key_value)
    # end
    # create_unlock_account_email do
    #   RodauthMailer.unlock_account(self.class.configuration_name, account_id, unlock_account_key_value)
    # end
    send_email do |email|
      # queue email delivery on the mailer after the transaction commits
      db.after_commit { email.deliver_later }
    end

    # ==> Flash
    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Change minimum number of password characters required when creating an account.
    # password_minimum_length 8

    # ==> Hooks
    # Validate custom fields in the create account form.
    # before_create_account do
    #   throw_error_status(422, "name", "must be present") if param("name").empty?
    # end

    # Perform additional actions after the account is created.
    # after_create_account do
    #   Profile.create!(account_id: account_id, name: param("name"))
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Profile.find_by!(account_id: account_id).destroy
    # end

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days.to_i
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    rails_account_model { User }
  end
end
