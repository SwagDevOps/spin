# frozen_string_literal: true

require 'forwardable'
require_relative '../controller'
require_relative './authenticable/class_methods'

# Authenticable behavior
#
# Sample of use:
#
# ```ruby
# class WebApp::Controller::Auth < WebApp::Controller::Base
#   include Spin::Controller::Authenticable
#   # add your own stuff
#   authenticable!
# end
# ```
module Spin::Controller::Authenticable
  extend(ClassMethods)
  extend(Forwardable)

  class << self
    def included(base)
      base.extend(ClassMethods)

      def_delegators(self, :urls)
    end
  end
end
