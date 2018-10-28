# frozen_string_literal: true

require 'warden'
use Warden::Manager do |config|
  config.serialize_into_session(&:username)
  config.serialize_from_session { |username| Spin::User.fetch(username) }

  config.failure_app = Spin::Controller::Auth
  config.scope_defaults(:default,
                        strategies: [:password],
                        action: '/unauthenticated')
end

before do
  @current_user = env['warden'].user
end

helpers do
  attr_reader :current_user
end
