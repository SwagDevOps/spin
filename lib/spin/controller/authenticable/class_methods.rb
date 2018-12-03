# frozen_string_literal: true

require_relative '../authenticable'

module Spin::Controller::Authenticable
  # Class methods
  module ClassMethods
    # Get urls.
    #
    # @return [Hash{Symbol => String}]
    def urls
      {
        logout: '/logout',
        login: '/login',
        after_logout: '/',
        success_login: '/',
        unauthenticated: '/unauthenticated',
      }
    end

    protected

    def login_view(controller)
      controller.tap do |c|
        if c.session[:return_to] == urls.fetch(:login)
          c.session[:return_to] = nil
        end

        if c.current_user
          c.redirect(c.session[:return_to] || urls.fetch(:success_login))
        end

        return c.erb(:login)
      end
    end

    def login(controller)
      controller.tap do |c|
        c.authenticate!

        c.flash[:success] = 'Logged in!'
        c.redirect(c.session[:return_to] || urls.fetch(:success_login))
      end
    end

    def logout(controller)
      controller.tap do |c|
        c.env['warden'].logout

        'Successfully logged out'.tap do |msg|
          c.flash[:success] = 'Successfully logged out'
          c.logger.info(msg)
        end

        c.redirect(urls.fetch(:after_logout))
      end
    end

    def unauthenticated(controller)
      controller.tap do |c|
        c.redirect(urls.fetch(:after_logout)) unless c.env['warden.options']

        c.session[:return_to] = c.env['warden.options'][:attempted_path]

        c.flash[:error] = c.env['warden'].message || 'You must log in'

        c.redirect(urls.fetch(:login))
      end
    end
  end
end
