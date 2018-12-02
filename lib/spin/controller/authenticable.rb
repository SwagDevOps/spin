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

  # Class methods
  module ClassMethods
    def login_get(controller)
      controller.tap do |c|
        c.session[:return_to] = nil if c.session[:return_to] == '/login'
        if c.current_user
          c.redirect(c.session[:return_to] || c.success_login_url)
        end

        return c.erb(:login)
      end
    end

    def login_post(controller)
      controller.tap do |c|
        c.authenticate!

        c.flash[:success] = 'Logged in!'
        c.redirect(c.session[:return_to] || c.success_login_url)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  class << self
    def included(base)
      base.extend(ClassMethods)

      base.get('/login') { self.class.login_get(self) }
      base.post('/login') { self.class.login_post(self) }

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
