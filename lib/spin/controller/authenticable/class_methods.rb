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

    # rubocop:disable Metrics/AbcSize

    # Register actions on given ``Class``.
    #
    # @param [Class] base
    # @see Spin::Controller::Authenticable.included
    #
    # @return [Class]
    def register_on(base)
      base.tap do |c|
        c.get(urls.fetch(:login)) { self.class.__send__(:login_view, self) }
        c.post(urls.fetch(:login)) { self.class.__send__(:login, self) }
        c.get(urls.fetch(:logout)) { self.class.__send__(:logout, self) }
        c.post(urls.fetch(:unauthenticated)) do
          self.class.__send__(:unauthenticated, self)
        end
      end
    end

    # rubocop:enable Metrics/AbcSize

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
          c.flash[:success] = msg
          c.logger.info(msg)
        end

        c.redirect(urls.fetch(:after_logout))
      end
    end

    def unauthenticated(controller)
      controller.tap do |c|
        c.env['warden.options'].tap do |options|
          c.redirect(urls.fetch(:after_logout)) unless options
          c.session[:return_to] = options[:attempted_path]
        end

        c.flash[:error] = c.env['warden'].message || 'You must log in'

        c.redirect(urls.fetch(:login))
      end
    end
  end
end
