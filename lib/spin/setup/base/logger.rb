# frozen_string_literal: true

# @see http://sinatrarb.com/contrib/custom_logger
require 'fileutils'
require 'logger'
require 'sinatra/custom_logger'

container[:storage_path].join('log').tap do |logdir|
  FileUtils.mkdir_p(logdir)

  logdir.join("#{self.settings.environment}.log").tap do |logfile|
    self.instance_eval do
      helpers Sinatra::CustomLogger

      ::Logger.new(logfile).tap do |logger|
        logger.level = ::Logger::DEBUG if development?

        configure { set(:logger, logger) }
      end
    end
  end
end

# logger.info 'Some message'
