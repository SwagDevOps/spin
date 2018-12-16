# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'sinatra/base'
require 'dry/inflector'
require 'dry/auto_inject'

# Base class
#
# Sample of use:
#
#
# ```ruby
# # config.ru
#
# require 'spin'
#
# run(Spin.controller)
# ```
class Spin
  require_relative 'spin/bundled'

  autoload(:Dotenv, 'dotenv')
  autoload(:Pathname, 'pathname')

  # @formatter:off
  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Config: :config,
    Container: :container,
    Controller: :controller,
    Helpers: :helpers,
    Initializer: :initializer,
    Setup: :setup,
    User: :user,
  }.each { |k, v| autoload(k, "#{__dir__}/spin/#{v}") }
  # @formatter:on

  # @return [Spin::Container]
  attr_reader :container

  def initialize
    @container = self.class.const(:DI).container
    if container.nil?
      raise 'Container must be set'
    end

    setup!
  end

  # @return [self]
  def setup!
    self.tap do
      Dotenv.load
      Setup.new(container).call
      Setup.new(container, :base_class).call
      Initializer.new(container).call

      container[:controller_class].__send__('config=', container[:config])
    end
  end

  # Use ``container`` to respond to missing nethods.
  #
  # @param [Symbol] method
  # @param [Array] args
  #
  # @return [Mixed]
  def method_missing(method, *args, &block)
    respond_to_missing?(method) ? self.container[method.to_sym] : super
  end

  def respond_to_missing?(method, include_private = false)
    container.key?(method.to_sym) || super(method, include_private)
  end

  class << self
    def const(const_name)
      const_name.to_s.gsub(/^::/, '').tap do |name|
        return Object.const_get("::#{self.name}::#{name}")
      end
    end

    # @return [Proc]
    def container_builder
      lambda do
        self.const(:Container).new.tap do |c|
          c.register(:paths, self.paths)
          c.register(:entry_class, self)
          c.register(:base_class, self.const(:Base))
          c.register(:config, config_builder.call)
          c.register(:controller_class, self.const(:Controller))
        end
      end
    end

    # @return [Proc]
    def config_builder
      lambda do
        self.const(:Config).tap do |config_class|
          config_class.__send__('paths=', self.paths)

          return config_class.new
        end
      end
    end

    def const_missing(name)
      if name.to_sym == :DI
        self.container_builder.call.tap do |container|
          self.const_set(name, Dry::AutoInject(container))

          return self.const_get(name)
        end
      end

      super
    end

    def constants
      super.push(:DI)
    end

    def const_defined?(sym, inherit = true)
      const_missing(sym) if sym == :DI and !super

      super
    end

    # Paths where ``setup`` file are resolved.
    #
    # @type [Array<Pathname>]
    def paths
      [Pathname.new(Dir.pwd).freeze,
       Pathname.new(__FILE__.gsub(/\.rb$/, '')).freeze].freeze
    end
  end
end
