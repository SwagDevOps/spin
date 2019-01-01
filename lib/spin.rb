# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'forwardable'
require 'dry/auto_inject'
require 'dry/inflector'

# rubocop:disable Metrics/ClassLength

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

  autoload(:Pathname, 'pathname')
  autoload(:Concurrent, 'concurrent')

  extend Forwardable

  # @formatter:off
  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Config: :config,
    Controller: :controller,
    Core: :core,
    Helpers: :helpers,
    User: :user,
  }.each { |k, v| autoload(k, "#{__dir__}/spin/#{v}") }
  # @formatter:on

  # @return [Spin::Container]
  attr_reader :container

  (@delegables = [:resolve]).tap do |delegables|
    def_delegators(*[self] + delegables)
  end

  def initialize
    resolve(:DI).container.tap do |container|
      @container = container

      raise 'Container must be set' if container.nil?
    end

    setup!
  end

  # @return [self]
  def setup!
    self.tap do
      self.class.__send__(:setup, container, :base_class)
      self.class.__send__(:init, container)

      container[:controller_class].__send__('config=', container[:config])
    end
  end

  class << self
    def inherited(subclass)
      super.tap do
        $INJECTOR = -> { subclass.const_get(:DI) }

        subclass.def_delegators(*[subclass] + @delegables)
        subclass.const_set(:Base, Class.new(self::Base))
      end
    end

    # rubocop:disable Metrics/MethodLength

    # Get an instance of container from a lambda.
    #
    # @return [Proc]
    def container_builder
      lambda do
        resolve('core/container').new.tap do |c|
          c.register(:entry_class, self)
          c.register(:base_class, self.const(:Base))
          c.register(:controller_class, self.const(:Controller))

          c.register(:paths, self.paths)
          c.register(:storage_path, Pathname.new(Dir.pwd).join('storage'))
          c.register(:config, config_builder.call)

          self.setup(c)
        end.freeze
      end
    end

    # rubocop:enable Metrics/MethodLength

    # @return [Proc]
    def config_builder
      lambda do
        resolve(:config).tap do |config_class|
          config_class.__send__('paths=', self.paths)

          return config_class.new
        end
      end
    end

    def const_missing(name)
      name.to_sym == :DI ? injector : super
    end

    # Returns an array of the names of accessible constants.
    #
    # @return [Array<Symbol>]
    def constants
      super.push(:DI).uniq
    end

    def const_defined?(sym, inherit = true)
      sym == :DI ? true : super
    end

    # Paths where ``setup`` file are resolved.
    #
    # @type [Array<Pathname>]
    def paths
      [Pathname.new(Dir.pwd).freeze,
       Pathname.new(__FILE__.gsub(/\.rb$/, '')).freeze].freeze
    end

    def resolve(name)
      Dry::Inflector.new.camelize(name).tap do |const_name|
        return self.const(const_name)
      end
    end

    protected

    # @param [String|Symbol]
    # @return [Class]
    def const(const_name)
      const_name.to_s.gsub(/^::/, '').tap do |name|
        return Object.const_get("::#{self.name}::#{name}")
      end
    end

    # @return [Dry::AutoInject::Builder]
    def injector
      unless (@injectors ||= Concurrent::Hash.new).key?(self.name)
        self.container_builder.call.tap do |container|
          @injectors[self.name] = Dry::AutoInject(container)
        end
      end

      @injectors[self.name]
    end

    # @see Spin::Core::Setup
    def setup(*args)
      self.const('Core::Setup').tap do |klass|
        # @type [Spin::Core::Setup] klass
        return klass.new(*args).call
      end
    end

    # @see Spin::Core::Initializer
    def init(*args)
      self.const('Core::Initializer').tap do |klass|
        # @type [Spin::Core::Initializer] klass
        return klass.new(*args).call
      end
    end
  end
end

# rubocop:enable Metrics/ClassLength
