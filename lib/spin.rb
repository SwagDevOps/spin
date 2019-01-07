# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'dry/auto_inject'
require 'dry/inflector'

# Base class
class Spin
  require_relative 'spin/bundled'

  autoload(:Pathname, 'pathname')
  autoload(:Concurrent, 'concurrent')

  # @formatter:off
  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Controller: :controller,
    Core: :core,
    Helpers: :helpers,
    User: :user,
  }.each { |k, v| autoload(k, "#{__dir__}/spin/#{v}") }
  # @formatter:on

  # @return [Spin::Container]
  attr_reader :container

  # @see @delegables ------------------------------------------------

  # @!method build(type, *args)
  #   @see .build
  #   @!visibility protected
  #   @param [String|Symbol] type
  #   @return [Spin::Core::Setup|Spin::Core::Initializer]

  # @!method resolve(name)
  #   @see .resolve
  #   @param [String|Symbol] name
  #   @return [Class]

  # -----------------------------------------------------------------
  extend Core::Forwardable

  (@delegables = [:build, :resolve]).tap do |delegables|
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
      build(:setup, container, :base_class).call
      build(:initializer, container).call
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

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize:

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

          c.register(:config, lambda do
            self.resolve('core/config').new.tap do |conf|
              conf.__send__(:paths=, paths.map { |path| path.join('config') })
            end
          end)

          self.build(:setup, c).call
        end.freeze
      end
    end

    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # @!parse DI = Dry::AutoInject(injector)
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

    # @see Spin::Core::Setup
    # @see Spin::Core::Initializer
    #
    # @return [Spin::Core::Setup|Spin::Core::Initializer]
    def build(type, *args)
      resolve("core/#{type}").tap do |klass|
        return klass.new(*args)
      end
    end

    # @param [String|Symbol] const_name
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
  end
end
