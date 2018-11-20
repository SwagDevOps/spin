# frozen_string_literal: true

require 'warden'

use Warden::Manager do |config|
  # rubocop:disable Style/SymbolProc
  config.serialize_into_session { |user| user.username }
  # rubocop:enable Style/SymbolProc
  config.serialize_from_session do |username|
    container[:entry_class]::User.fetch(username)
  end

  config.failure_app = container[:entry_class]::Controller::Auth
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
