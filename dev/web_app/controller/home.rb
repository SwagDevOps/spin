# frozen_string_literal: true

require 'spin/controller/base'
require_relative '../controller'

# Home controller
class WebApp::Controller::Home < WebApp::Controller::Auth
  get('/') { erb(:welcome) }
end
