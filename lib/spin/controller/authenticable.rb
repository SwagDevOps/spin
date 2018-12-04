# frozen_string_literal: true

require 'forwardable'
require_relative '../controller'
require_relative './authenticable/class_methods'

# Authenticable behavior
module Spin::Controller::Authenticable
  extend(ClassMethods)
  extend(Forwardable)

  def_delegators(self, :urls)

  class << self
    def included(base)
      base.extend(ClassMethods)

      pp register_on(base)
    end
  end
end
