# frozen_string_literal: true

require_relative './base'

# Class for posts admin
class WebApp::Controller::Admin < WebApp::Controller::Base
  autoload(:Pathname, 'pathname')

  # @api private
  BASE_URI = Pathname.new('/admin')

  class << self
    # @return [Pathname]
    def base_uri
      self::BASE_URI.clone
    end
  end

  # @formatter:off
  {
    Posts: 'posts',
  }.each { |k, v| autoload(k, "#{__dir__}/admin/#{v}") }
  # @formatter:on

  get(base_uri.to_s) { erb :protected }
end
