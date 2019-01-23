# frozen_string_literal: true

require_relative './base'
require 'spin/controller/authenticable'

# Auth controller
class WebApp::Controller::Auth < WebApp::Controller::Base
  include Spin::Controller::Authenticable

  class << self
    def urls
      WebApp::Controller::Admin.base_uri.to_s.tap do |url|
        # formatter:off
        return super.merge(
          protected: url,
          success_login: url
        )
        # formatter:on
      end
    end
  end

  authenticable!

  before(%r{#{urls.fetch(:protected)}(/.*)*}) { authenticate! }
end
