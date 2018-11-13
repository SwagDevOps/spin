# frozen_string_literal: true

require 'spin/controller'
require 'dry/inflector'

# Base controller
class WebApp::Controller < Spin::Controller
  autoload_self
end
