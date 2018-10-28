# frozen_string_literal: true

# @see http://sinatrarb.com/contrib/custom_logger
require 'fileutils'
require 'logger'
require 'sinatra/custom_logger'

"log/#{self.settings.environment}.log".tap do |logfile|
  File.dirname(logfile).tap { |logdir| FileUtils.mkdir_p(logdir) }

  self.instance_eval do
    helpers Sinatra::CustomLogger

    ::Logger.new(logfile).tap do |logger|
      logger.level = ::Logger::DEBUG

      configure { set(:logger, logger) }
    end
  end
end

# logger.info 'Some message' # STDOUT logger is used
