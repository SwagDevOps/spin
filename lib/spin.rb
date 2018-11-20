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
  }.each { |k, v| autoload k, "#{__dir__}/spin/#{v}" }

  # rubocop:disable Style/ClassVars

  @@loaded = false
  # rubocop:enable Style/ClassVars

  attr_reader :container

  def initialize
    # rubocop:disable Style/GlobalVars
    $ENTRY_CLASS = self.class
    # rubocop:enable Style/GlobalVars
    @container = self.class.const(:Import).container

    setup!
  end

  # @return [self]
  def setup!
    self.tap do
      Dotenv.load
      Setup.new(container, :base_class).call
      Initializer.new(self.class.paths).call
    end
  end

  class << self
    def const(const_name)
      const_name.to_s.gsub(/^::/, '').tap do |name|
        return Object.const_get("::#{self.name}::#{name}")
      end
    end

    # @return [Spin::Container]
    def container_builder
      lambda do
        self.const(:Container).new.tap do |c|
          c.register(:paths, self.paths)
          c.register(:entry_class, self)
          c.register(:base_class, self.const(:Base))
          c.register(:config, self.const(:Config).new)
          c.register(:controller_class, self.const(:Controller))
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

    # @return [self]
    def setup!
      return self if @@loaded

      self.tap do
        # rubocop:disable Style/GlobalVars
        $ENTRY_CLASS = self
        # rubocop:enable Style/GlobalVars

        Dotenv.load
        Setup.new(base_class, 'base', paths).call
        Initializer.new(paths).call
        # rubocop:disable Style/ClassVars
        @@loaded = true
        # rubocop:enable Style/ClassVars
      end
    end

    # Get an instance of main controller.
    #
    # @return [Controller]
    def controller
      setup!

      Object.const_get("::#{self.name}::Controller").mount!
    end

    # Resolve base class ``Base``
    #
    # @return [Class]
    def base_class
      Object.const_get("::#{self.name}::Base")
    end

    # Get config.
    #
    # @return [Config]
    def config
      Object.const_get("::#{self.name}::Config").new
    end

    def setup_entry_class!
      (self.ancestors - Object.ancestors).last.tap do |entry_class|
        unless entry_class.const_defined?(:ENTRY_CLASS, false)
          entry_class.const_set(:ENTRY_CLASS, self)
        end
      end
    end
  end
end
