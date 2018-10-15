# frozen_string_literal: true

require_relative '../mount'

# Sinatra includes a number of built-in settings
# that control whether certain features are enabled.
#
# @see http://sinatrarb.com/configuration.html
class Spin::Mount::Config < Spin::Mount
  def call
    config.tap do |config|
      self.variables.tap do |variables|
        base_class.instance_eval do
          configure do
            config.each { |k, v| set(k, v % variables) }
          end
        end
      end

      base_class
    end
  end

  # Get variables
  #
  # @return [Hash{Symbol => String|Object}]
  def variables
    {
      pwd: Dir.pwd,
      libdir: Pathname.new(__FILE__).dirname.join('..').realpath.to_s
    }
  end
end
