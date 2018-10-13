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
class Spin < Sinatra::Base
  {
    VERSION: :version,
    Controller: :controller,
  }.each { |k, v| autoload k, "#{__dir__}/spin/#{v}" }

  class << self
    def controllers
      [:home]
    end

    def configuration
      {
        public_folder: 'public',
        views: 'views'
      }
    end

    def mount
      self.tap do
        apply_configuration!
        mount_controllers!
      end
    end

    protected

    def apply_configuration!
      configuration = self.configuration

      Sinatra::Base.instance_eval do
        configuration.tap do |c|
          configure do
            c.each { |k, v| set(k, v) }
          end
        end
      end
    end

    def mount_controllers!
      Dry::Inflector.new.tap do |inf|
        self.controllers.each do |name|
          self.instance_eval do
            use self.const_get("Controller::#{inf.camelize(name)}")
          end
        end
      end
    end
  end
end
