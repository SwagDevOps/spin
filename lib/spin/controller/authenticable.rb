# frozen_string_literal: true

require 'forwardable'
require_relative '../controller'
require_relative './authenticable/class_methods'

# Authenticable behavior
module Spin::Controller::Authenticable
  extend(ClassMethods)
  extend(Forwardable)

  def_delegators(self, :urls)

  # rubocop:disable Metrics/AbcSize
  class << self
    def included(base)
      base.extend(ClassMethods)

      base.get(urls.fetch(:login)) { self.class.__send__(:login_view, self) }
      base.post(urls.fetch(:login)) { self.class.__send__(:login, self) }
      base.get(urls.fetch(:logout)) { self.class.__send__(:logout, self) }

      base.post(urls.fetch(:unauthenticated)) do
        self.class.__send__(:unauthenticated, self)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
end
