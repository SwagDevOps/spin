# frozen_string_literal: true

require_relative './base'

# Authenticable behavior
module Spin::Controller::Authenticable
  def after_logout_url
    '/'
  end

  def success_login_url
    '/'
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  class << self
    def included(base)
      base.get '/login' do
        session[:return_to] = nil if session[:return_to] == '/login'
        redirect(session[:return_to] || success_login_url) if current_user

        erb :login
      end

      base.post '/login' do
        self.authenticate!

        flash[:success] = 'Logged in!'
        redirect(session[:return_to] || success_login_url)
      end

      base.get '/logout' do
        env['warden'].logout

        'Successfully logged out'.tap do |msg|
          flash[:success] = 'Successfully logged out'
          logger.info(msg)
        end

        redirect(after_logout_url)
      end

      base.post '/unauthenticated' do
        redirect '/' unless env['warden.options']

        session[:return_to] = env['warden.options'][:attempted_path]

        flash[:error] = env['warden'].message || 'You must log in'
        redirect '/login'
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
