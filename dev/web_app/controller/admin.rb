# frozen_string_literal: true

require_relative './base'

# Class for posts admin
class WebApp::Controller::Admin < WebApp::Controller::Base
  BASE_URI = Pathname.new('/admin')

  # @formatter:off
  {
    Posts: 'posts',
  }.each { |k, v| autoload(k, "#{__dir__}/admin/#{v}") }
  # @formatter:on

  get(BASE_URI.to_s) { erb :protected }
end
