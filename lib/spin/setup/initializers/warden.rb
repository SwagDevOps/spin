# frozen_string_literal: true

if Gem::Specification.find_all_by_name('warden').any?
  require 'warden'

  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = 'POST'

    env['rack.input'] = lambda do
      { '_csrf' => Rack::Csrf.csrf_token(env) }.tap do |params|
        Rack::Utils.build_nested_query(params).tap do |query|
          return StringIO.new(query)
        end
      end
    end.call
  end

  container[:entry_class].tap do |entry_class|
    Warden::Strategies.add(:password) do
      @entry_class = entry_class

      class << self
        attr_reader :entry_class
      end

      # Denote request validity.
      #
      # @return Boolean
      def valid?
        params['username'] && params['password']
      end

      def authenticate!
        user_class = self.class.entry_class::User

        user_class.fetch(params['username'], nil).tap do |user|
          # rubocop:disable Style/GuardClause
          if user&.authenticate(params['password'])
            return success!(user)
          else
            return fail!('Could not log in')
          end
          # rubocop:enable Style/GuardClause
        end
      end
    end
  end
end
