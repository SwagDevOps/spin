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
class WebApp::Controller::Base < WebApp::Base
  # A new instance of Base.
  #
  # @param [WebApp::Controller|nil] app
  def initialize(app = nil, **)
    super(app)
  end
end
