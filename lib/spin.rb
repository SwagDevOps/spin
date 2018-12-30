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
  autoload(:Concurrent, 'concurrent')

  # @formatter:off
  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Config: :config,
    ConfigReader: :config_reader,
    Container: :container,
    Controller: :controller,
    Core: :core,
    Helpers: :helpers,
    Initializer: :initializer,
    Injectable: :injectable,
    Setup: :setup,
    User: :user,
  }.each { |k, v| autoload(k, "#{__dir__}/spin/#{v}") }
  # @formatter:on

  # @return [Spin::Container]
  attr_reader :container

  def initialize
    @container = self.class.const(:DI).container
    raise 'Container must be set' if container.nil?

    setup!
  end

  # @return [self]
  def setup!
    self.tap do
      Dotenv.load
      Setup.new(container, :base_class).call
      Initializer.new(container).call

      container[:controller_class].__send__('config=', container[:config])
    end
  end

  class << self
    def inherited(subclass)
      super.tap do
        $INJECTOR = -> { subclass.const_get(:DI) }

        subclass.const_set(:Base, Class.new(self::Base))
      end
    end

    def const(const_name)
      const_name.to_s.gsub(/^::/, '').tap do |name|
        return Object.const_get("::#{self.name}::#{name}")
      end
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

    # Get an instance of container from a lambda.
    #
    # @return [Proc]
    def container_builder
      lambda do
        self.const(:Container).new.tap do |c|
          c.register(:entry_class, self)

          c.register(:paths, self.paths)
          c.register(:storage_path, Pathname.new(Dir.pwd).join('storage'))
          c.register(:base_class, self.const(:Base))
          c.register(:config, config_builder.call)
          c.register(:controller_class, self.const(:Controller))

          Setup.new(c).call
        end.freeze
      end
    end

    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
      return injector if name.to_sym == :DI

      super
    end

    # Returns an array of the names of accessible constants.
    #
    # @return [Array<Symbol>]
    def constants
      super.push(:DI).uniq
    end

    def const_defined?(sym, inherit = true)
      # const_missing(sym) if sym == :DI and !super
      return true if sym == :DI

      super
    end

    # Paths where ``setup`` file are resolved.
    #
    # @type [Array<Pathname>]
    def paths
      [Pathname.new(Dir.pwd).freeze,
       Pathname.new(__FILE__.gsub(/\.rb$/, '')).freeze].freeze
    end

    protected

    # @return [Dry::AutoInject::Builder]
    def injector
      unless (@injectors ||= Concurrent::Hash.new).key?(self.name)
        self.container_builder.call.tap do |container|
          @injectors[self.name] = Dry::AutoInject(container)
        end
      end

      @injectors[self.name]
    end
  end
end
