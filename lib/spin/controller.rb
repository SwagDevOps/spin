# frozen_string_literal: true

require_relative '../spin'
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

  class << self
    # Get routing as seen during mount.
    #
    # @return [Hash{String => Class}]
    def routing
      # @formatter:off
      config['app.routing']
        .to_h.map { |path, name| [path, resolve(name)] }.to_h.freeze
      # @formatter:on
    end

    # Mount controllers.
    #
    # @param [Rack::Builder] builder
    #
    # @return [self]
    def mount!(builder)
      routing.map do |path, controller|
        builder.map(path.to_s) { run(controller) }
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

    # Resolve class by name relatively to current controller.
    #
    # @param [String] name
    #
    # @return [Class]
    def resolve(name)
      unless name =~ /^([A-Z]|::[A-Z])/
        name = "#{self}::#{Dry::Inflector.new.camelize(name)}"
      end

      Object.const_get(name)
    end
  end
end
