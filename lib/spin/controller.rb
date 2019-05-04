# frozen_string_literal: true

require 'spin'
require 'dry/inflector'

# Base controller
#
# Used for autoloading.
#
# @see https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html
class Spin::Controller < Spin::Base
  include Spin::Core::Injectable
  include Spin::Core::Autoloadable

  autoload_self

  # @type [Spin::Core::Config]
  @config = nil

  set :routes, @routes

  class << self
    # Mount controllers.
    #
    # @param [Rack::Builder] builder
    #
    # @return [self]
    def mount!(builder)
      Dry::Inflector.new.tap do |inf|
        config['app.routing'].to_h.to_a.each do |path, name|
          name = "#{self}::#{inf.camelize(name)}" unless name =~ /^[A-Z]/

          builder.map(path.to_s) { run Object.const_get(name) }
        end
      end

      self
    end

    # @param [Rack::Builder] builder
    #
    # @return [self]
    def run!(builder)
      self.mount!(builder).tap do |app|
        return builder.run(app)
      end
    end

    protected

    # @type [Spin::Config]
    attr_writer :config

    # Get config.
    #
    # @return [Spin::Core::Config|nil]
    def config
      # rubocop:disable Style/NilComparison
      @config || (injector == nil ? nil : injector.container[:config])
      # rubocop:enable Style/NilComparison
    end
  end
end
