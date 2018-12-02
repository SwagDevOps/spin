# frozen_string_literal: true

module Spin::Controller::Authenticable
  # Class methods
  module ClassMethods
    protected

    def login_view(controller)
      controller.tap do |c|
        c.session[:return_to] = nil if c.session[:return_to] == '/login'
        if c.current_user
          c.redirect(c.session[:return_to] || c.success_login_url)
        end

        return c.erb(:login)
      end
    end

    def login(controller)
      controller.tap do |c|
        c.authenticate!

        c.flash[:success] = 'Logged in!'
        c.redirect(c.session[:return_to] || c.success_login_url)
      end
    end

    def logout(controller)
      controller.tap do |c|
        c.env['warden'].logout

        'Successfully logged out'.tap do |msg|
          c.flash[:success] = 'Successfully logged out'
          c.logger.info(msg)
        end

        c.redirect(c.after_logout_url)
      end
    end

    def unauthenticated(controller)
      controller.tap do |c|
        c.redirect(c.after_logout_url) unless c.env['warden.options']

        c.session[:return_to] = c.env['warden.options'][:attempted_path]

        c.flash[:error] = c.env['warden'].message || 'You must log in'

        c.redirect('/login')
      end
    end
  end
end
