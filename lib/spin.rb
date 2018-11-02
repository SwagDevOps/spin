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
    EntryClass: :entry_class,
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

  # extend EntryClass
  extend(EntryClass)

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

    # Get config.
    #
    # @return [Config]
    def config
      Config.new
    end
  end
end
