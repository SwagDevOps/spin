# frozen_string_literal: true

require_relative './base'
require_relative '../authenticator'

# Class for admin
class WebApp::Controller::Admin < WebApp::Controller::Base
  autoload(:Pathname, 'pathname')

  use WebApp::Authenticator

  # @formatter:off
  {
    Posts: 'posts',
  }.each { |k, v| autoload(k, "#{__dir__}/admin/#{v}") }
  # @formatter:on

  get('/') { erb(:protected) }
end
