# frozen_string_literal: true

require_relative '../mount'

# Sinatra includes a number of built-in settings
# that control whether certain features are enabled.
#
# @see http://sinatrarb.com/configuration.html
class Spin::Mount::Config < Spin::Mount
  def call
    base_class.tap do |base_class|
      config.tap do |config|
        base_class.instance_eval do
          configure do
            config.each { |k, v| set(k, v) }
          end
        end
      end
    end
  end
end
