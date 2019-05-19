# frozen_string_literal: true

require_relative '../controller'

# Base controller
#
# Use ``WebApp::DI`` with ``kwargs`` strategy.
#
# @see https://dry-rb.org/gems/dry-auto_inject/injection-strategies/
# @see https://github.com/dry-rb/dry-auto_inject/issues/29
#
# Sample of use:
#
# ```ruby
# class WebApp::Controller::Sample < WebApp::Controller::Base
#   send(:include, WebApp::DI.kwargs[:sample_service])
#
#   def initialize(app = nil, **options)
#     @service = options[:sample_service]
#
#     super(app)
#   end
# end
# ```
#
# or (using ``Injectable``):
#
# ```ruby
# class WebApp::Controller::Sample < WebApp::Controller::Base
#   include WebApp::Injectable
#
#   inject(:sample_service)
#
#   def initialize(app = nil, **options)
#     @service = options[:sample_service]
#
#     super(app)
#   end
# end
# ```
class WebApp::Controller::Base < WebApp::Base
  include WebApp::Core::Injectable

  inject(:config)

  # @return [Spin::Core::Config]
  attr_reader :config

  # A new instance of Base.
  #
  # @param [WebApp::Controller|nil] app
  def initialize(app = nil, **options)
    super(app)

    @config = options[:config]
  end

  # Errors available
  #
  # * 400 Bad Request
  # * 401 Unauthorized
  # * 403 Forbidden
  # * 404 Not Found
  # * 405 Method not allowed
  # * 419 Authentication Timeout
  # * 429 Too Many Requests
  # * 500 Internal Server Error
  # * 502 Bad Gateway
  # * 503 Service Unavailable
  # * 504 Gateway Timeout
  #
  # TODO handle more errors
  [403, 404].each do |code|
    error code do
      erb(:"errors/#{code}", layout: false)
    end
  end

  # Errors available
  #
  # * 400 Bad Request
  # * 401 Unauthorized
  # * 403 Forbidden
  # * 404 Not Found
  # * 405 Method not allowed
  # * 419 Authentication Timeout
  # * 429 Too Many Requests
  # * 500 Internal Server Error
  # * 502 Bad Gateway
  # * 503 Service Unavailable
  # * 504 Gateway Timeout
  #
  # TODO handle more errors
  [403, 404].each do |code|
    error code do
      erb(:"errors/#{code}", layout: false)
    end
  end
end
