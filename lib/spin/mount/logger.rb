# frozen_string_literal: true

require_relative '../mount'

require 'fileutils'
require 'logger'
require 'pathname'
require 'sinatra/custom_logger'

# This library provides an interface for ``SemanticLogger``
#
# Sample of use:
#
# ```ruby
# logger.info "some info"
# logger.debug "some debugging"
# ```
#
# @see https://github.com/minodes/sinatra-logger
# @see https://github.com/rocketjob/semantic_logger
class Spin::Mount::Logger < Spin::Mount
  # @return [Hash]
  def config
    super.to_h.tap do |c|
      c['filename'] ||= "#{c['path']}/#{base_class.settings.environment}.log"
      if c['level'].is_a?(String)
        c['level'] = Object.const_get("::Logger::#{c['level']}")
      end
    end
  end

  def call
    return base_class unless logger

    base_class.tap do |base_class|
      self.logger.tap do |logger|
        base_class.instance_eval do
          helpers Sinatra::CustomLogger

          configure { set(:logger, logger) }
        end
      end
    end
  end

  # @return [::Logger]
  def logger
    return if false == config['logging']

    config.fetch('filename').tap do |filename|
      prepare_logdir(filename)

      ::Logger.new(filename).tap do |logger|
        logger.level = config['level']
      end
    end
  end

  protected

  # @return [Pathname]
  def prepare_logdir(filename = nil)
    filename ||= config.fetch('filename')

    Pathname.new(filename).dirname.tap do |logdir|
      FileUtils.mkdir_p(logdir)
    end
  end
end
