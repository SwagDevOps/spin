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

  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Config: :config,
    Container: :container,
    Controller: :controller,
    Initializer: :initializer,
    Setup: :setup,
    User: :user,
  }.each { |k, v| autoload(k, "#{__dir__}/spin/#{v}") }

  # @return [Spin::Container]
  attr_reader :container

  def initialize
    @container = self.class.const(:Import).container

    setup!
  end

  # @return [self]
  def setup!
    self.tap do
      Dotenv.load
      Setup.new(container, :base_class).call
      Initializer.new(container).call
    end
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

          config_class.new
        end
      end
    end

    def const_missing(name)
      if name.to_sym == :Import
        self.container_builder.call.tap do |container|
          self.const_set(name, Dry::AutoInject(container))

          return self.const_get(name)
        end
      end

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
