# frozen_string_literal: true

if Gem::Specification.find_all_by_name('warden').any?
  require 'warden'

  container[:entry_class].tap do |entry_class|
    use Warden::Manager do |config|
      # rubocop:disable Style/SymbolProc
      config.serialize_into_session { |user| user.username }
      # rubocop:enable Style/SymbolProc
      config.serialize_from_session do |username|
        entry_class::User.fetch(username)
      end

      config.failure_app = container[:entry_class]::Controller::Auth
      config.scope_defaults(:default,
                            strategies: [:password],
                            action: '/unauthenticated')
    end
  end

  before do
    @current_user = env['warden'].user
  end

  helpers do
    attr_reader :current_user

    def authenticate!
      env.fetch('warden').authenticate!
    end
  end
end
