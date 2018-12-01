# frozen_string_literal: true

require_relative './base'
require 'spin/controller/authenticable'

# Auth controller
class WebApp::Controller::Auth < WebApp::Controller::Base
  include Spin::Controller::Authenticable

  def success_login_url
    '/protected'
  end

  get '/protected' do
    erb :protected
  end

  before %r{/protected} do
    authenticate!
  end
end
