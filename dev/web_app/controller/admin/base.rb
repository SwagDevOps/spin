# frozen_string_literal: true

require_relative '../auth'

# @abstract
class WebApp::Controller::Admin::Base < WebApp::Controller::Base
  class << self
    # @return [Pathname]
    def base_uri
      WebApp::Controller::Admin.base_uri
    end

    # @see Sinatra::Base
    %w[get put post delete head options patch link unlink].each do |method|
      define_method(method) do |path, opts = {}, &bk|
        path = path.gsub(%r{^/*}, '')

        return super(base_uri.join(path).to_path, opts, &bk)
      end
    end
  end
end
