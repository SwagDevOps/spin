# frozen_string_literal: true

require_relative './base'
require 'spin/controller/authenticable'

# Auth controller
class WebApp::Controller::Auth < WebApp::Controller::Base
  include Spin::Controller::Authenticable

  class << self
    def urls
      super.merge(
        protected: '/protected',
        success_login: '/protected'
      )
    end
  end

  get(urls.fetch(:protected)) { erb :protected }

  before(/#{urls.fetch(:protected)}/) { authenticate! }
end
