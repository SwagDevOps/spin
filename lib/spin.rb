# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'sinatra/base'
require 'dry/inflector'

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
    Controller: :controller,
    EntryClass: :entry_class,
    Initializer: :initializer,
    Setup: :setup,
    User: :user,
  }.each { |k, v| autoload k, "#{__dir__}/spin/#{v}" }

  # extend EntryClass
  extend(EntryClass)

  # rubocop:disable Style/ClassVars
  @@loaded = false
  # rubocop:enable Style/ClassVars

  class << self
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
        self.setup_entry_class!
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
  end
end
