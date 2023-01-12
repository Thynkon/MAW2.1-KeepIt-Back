# frozen_string_literal: true

require 'jwt'
module JsonWebToken
    extend ActiveSupport::Concern

    # secret to encode and decode token
    HMAC_SECRET = Rails.application.secrets.secret_key_base

    def self.encode(payload, exp = 7.days.from_now)
        # set expiry to 7 days from creation time
        payload[:exp] = exp.to_i
        # sign token with application secret
        JWT.encode(payload, HMAC_SECRET)
    end

    def self.decode(token)
        puts "token: #{token}"
        # get payload; first index in decoded Array
        body = JWT.decode(token, HMAC_SECRET)[0]
        HashWithIndifferentAccess.new body
        # rescue from all decode errors
    end
end