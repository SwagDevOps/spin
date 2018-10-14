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
# run Spin.mount
# ```
class Spin
  {
    VERSION: :version,
    Autoloadable: :autoloadable,
    Base: :base,
    Config: :config,
    Controller: :controller,
    Mount: :mount,
  }.each { |k, v| autoload k, "#{__dir__}/spin/#{v}" }

  class << self
    # Get mountables.
    #
    # @return [Array<Symbol>]
    def mountables
      [:config, :logger]
    end

    # @return [Controller]
    def mount
      mountables.each { |name| mount!(name) }

      return Controller.mount!
    end

    protected

    # @return [Config]
    def config(name = :config)
      Config.new(name)
    end

    # @return [Base|Spin]
    def mount!(name)
      Base.tap do |base_class|
        Dry::Inflector.new.tap do |inf|
          self.const_get("Mount::#{inf.camelize(name)}").tap do |klass|
            klass.new(base_class, config(name)).call
          end
        end
      end
    end
  end
end
