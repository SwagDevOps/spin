# frozen_string_literal: true

# @see https://github.com/baldowl/rack_csrf
require 'rack/csrf'

configure do
  use Rack::Csrf, raise: true
end

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end
end
