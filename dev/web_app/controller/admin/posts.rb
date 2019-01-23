# frozen_string_literal: true

require_relative './base'

# Class for posts (admin) management
class WebApp::Controller::Admin::Posts < WebApp::Controller::Admin::Base
  get('/posts') { erb(:'admin/posts/index') }
end
