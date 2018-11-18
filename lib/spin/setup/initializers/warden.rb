# frozen_string_literal: true

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

Warden::Strategies.add(:password) do
  # Denote request validity.
  #
  # @return Boolean
  def valid?
    params['username'] && params['password']
  end

  def authenticate!
    # rubocop:disable Style/GlobalVars
    $ENTRY_CLASS::User.fetch(params['username'], nil).tap do |user|
      # rubocop:enable Style/GlobalVars
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
