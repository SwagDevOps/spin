# frozen_string_literal: true

require_relative '../auth'

# Class for posts (admin) management
class WebApp::Controller::Admin::Posts < WebApp::Controller::Base
  WebApp::Controller::Admin::BASE_URI.tap do |admin_uri|
    get(admin_uri.clone.join('posts').to_s) { erb(:welcome) }
  end
end
