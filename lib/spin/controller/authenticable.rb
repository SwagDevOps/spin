# frozen_string_literal: true

require_relative './base'

# Authenticable behavior
module Spin::Controller::Authenticable
  autoload(:ClassMethods, "#{__dir__}/authenticable/class_methods")

  def after_logout_url
    '/'
  end

  def success_login_url
    '/'
  end

  class << self
    def included(base)
      base.extend(ClassMethods)

      base.get('/login') { self.class.__send__(:login_view, self) }
      base.post('/login') { self.class.__send__(:login, self) }
      base.get('/logout') { self.class.__send__(:logout, self) }

      base.post('/unauthenticated') do
        self.class.__send__(:unauthenticated, self)
      end
    end
  end
end
