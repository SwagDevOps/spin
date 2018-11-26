# frozen_string_literal: true

require 'spin'
require 'dry/inflector'

# Base controller
#
# Used for autoloading.
#
# @see https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html
class Spin::Controller < Spin::Base
  include Spin::Autoloadable

  autoload_self

  # @type [Spin::Config]
  @config = nil

  class << self
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

    protected

    # @type [Spin:;Config]
    attr_accessor :config
  end
end
