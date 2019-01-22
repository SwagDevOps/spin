# frozen_string_literal: true

require_relative '../auth'

# @abstract
class WebApp::Controller::Admin::Base < WebApp::Controller::Base
  BASE_URI = WebApp::Controller::Admin::BASE_URI

  class << self
    %w[get put post delete head options patch link unlink].each do |method|
      define_method(method) do |path, opts = {}, &bk|
        BASE_URI.tap do |admin_uri|
          return super(admin_uri.clone.join(path).to_s, opts, &bk)
        end
      end
    end
  end
end
