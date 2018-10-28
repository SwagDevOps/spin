# frozen_string_literal: true

require_relative '../spin'
require 'dry/inflector'

# Base controller
#
# Used for autoloading.
#
# @see https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html
class Spin::Controller < Spin::Base
  include Spin::Autoloadable

  autoload_self

  class << self
    # @raise [RuntimeError]
    def inherited(*)
      raise "Do not inherit #{self}, use #{Spin::Base} instead"
    end

    # Mount controllers.
    #
    # @return [self]
    def mount!
      Dry::Inflector.new.tap do |inf|
        config.fetch('controllers', []).each do |name|
          name = "#{self}::#{inf.camelize(name)}" unless name =~ /^[A-Z]/

          use Object.const_get(name)
        end
      end

      self
    end
  end
end
