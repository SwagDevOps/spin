# frozen_string_literal: true

require_relative './base'
require 'spin/controller/authenticable'

# Auth controller
class WebApp::Controller::Auth < WebApp::Controller::Base
  include Spin::Controller::Authenticable

  class << self
    def urls
      WebApp::Controller::Admin::BASE_URI.to_s.tap do |uri|
        # formatter:off
        return super.merge(
          protected: uri,
          success_login: uri
        )
        # formatter:on
      end
    end
  end

  authenticable!

  before(%r{#{urls.fetch(:protected)}(/.*)*}) { authenticate! }
end
