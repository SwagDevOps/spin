# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'sinatra/base'
require 'dry/inflector'

require_relative 'spin/bundled'

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
  autoload(:Dotenv, 'dotenv')

  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Config: :config,
    Controller: :controller,
    Initializer: :initializer,
    Setup: :setup,
    User: :user,
  }.each { |k, v| autoload k, "#{__dir__}/spin/#{v}" }

  # Paths where ``setup`` file are resolved.
  #
  # @type [Array<Pathname>]
  @paths = [
    Pathname.new(Dir.pwd).freeze,
    Pathname.new(__FILE__.gsub(/\.rb$/, '')).freeze,
  ]

  class << self
    attr_accessor :paths

    # @return [self]
    def setup!
      self.tap do
        self.setup_entry_class!

        Dotenv.load
        Setup.new(base_class, 'base', paths).call
        Initializer.new(paths).call
      end
    end

    # Get an instance of main controller.
    #
    # @return [Controller]
    def controller
      setup!

      Controller.mount!
    end

    # Resolve base class ``Base``
    #
    # @return [Class]
    def base_class
      Object.const_get("::#{self.name}::Base")
    end

    def entry_class
      @@entry_class || self
    end

    def const_missing(name)
      if self.const_defined?(name)
        return self.public_send(name.to_s.downcase)
      end

      super
    end

    def const_defined?(name)
      if [:ENTRY_CLASS].include?(name)
        return true
      end

      super
    end

    # Get config.
    #
    # @return [Config]
    def config
      Config.new
    end

    protected

    # @return [Class]
    def setup_entry_class!
      # rubocop:disable Style/ClassVars
      @@entry_class = Object.const_get("::#{self.name}")
      # rubocop:enable Style/ClassVars
    end
  end
end
