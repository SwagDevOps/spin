# frozen_string_literal: true

require_relative '../web_app'

# Authenticator middleware
class WebApp::Authenticator
  # @param [Sinatra::Base] app
  def initialize(app)
    self.app = app
  end

  # @param [Hash] env
  def call(env)
    env.fetch('warden').authenticate!

    app.call(env)
  end

  protected

  # @return [Sinatra::Base]
  attr_accessor :app
end
