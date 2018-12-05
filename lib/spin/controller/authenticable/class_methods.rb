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

    # Get actions as ``[url, method, action]``.
    #
    # @return [Array<Array>]
    def actions
      [
        [:login, :get, :login_view],
        [:login, :post, :login],
        [:logout, :get, :logout],
        [:unauthenticated, :post, :unauthenticated]
      ].map do |url_name, method, action|
        [urls.fetch(url_name), method, action]
      end
    end

    # Register actions on given ``Class``.
    #
    # @param [Class] base
    # @see Spin::Controller::Authenticable.included
    #
    # @return [Class]
    def register_on(base)
      base.tap do |c|
        actions.each do |url, method, action|
          c.public_send(method, url) { self.class.__send__(action, self) }
        end
      end
    end

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
