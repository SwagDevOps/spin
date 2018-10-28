# frozen_string_literal: true

require_relative 'base'

# Auth controller
class Spin::Controller::Auth < Spin::Controller::Base
  get '/login' do
    session[:return_to] = nil if session[:return_to] == '/login'
    redirect(session[:return_to] || '/protected') if current_user

    erb :login
  end

  post '/login' do
    self.authenticate!

    flash[:success] = 'Logged in!'
    redirect(session[:return_to] || '/protected')
  end

  get '/logout' do
    env['warden'].logout

    'Successfully logged out'.tap do |msg|
      flash[:success] = 'Successfully logged out'
      logger.info(msg)
    end

    redirect '/'
  end

  post '/unauthenticated' do
    redirect '/' unless env['warden.options']

    session[:return_to] = env['warden.options'][:attempted_path]

    flash[:error] = env['warden'].message || 'You must log in'
    redirect '/login'
  end

  get '/protected' do
    erb :protected
  end

  before %r{/protected} do
    authenticate!
  end
end
