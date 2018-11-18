# frozen_string_literal: true

require 'warden'

# rubocop:disable Style/GlobalVars
use Warden::Manager do |config|
  # rubocop:disable Style/SymbolProc
  config.serialize_into_session { |user| user.username }
  # rubocop:enable Style/SymbolProc
  config.serialize_from_session do |username|
    # @todo use dependency injection
    $ENTRY_CLASS::User.fetch(username)
  end

  config.failure_app = $ENTRY_CLASS::Controller::Auth
  config.scope_defaults(:default,
                        strategies: [:password],
                        action: '/unauthenticated')
end
# rubocop:enable Style/GlobalVars

before do
  @current_user = env['warden'].user
end

helpers do
  attr_reader :current_user
end
