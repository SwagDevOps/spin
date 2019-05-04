#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'dev/web_app'
require 'rack'
require 'pathname'

# ``Rack::Builder`` fixing some environment variables.
#
# Fix: ``SCRIPT_NAME``, ``PATH_INFO`` and ``QUERY_STRING``
class Rack::FastCGI < Rack::Builder
  autoload(:URI, 'uri')

  def call(env)
    URI(env.fetch('REQUEST_URI')).tap do |uri|
      env['SCRIPT_NAME'] = '/'
      env['PATH_INFO'] = uri.path
      env['QUERY_STRING'] = uri.query
    end

    to_app.call(env)
  end
end

# Provide a logger built into an IO to replace ``STDOUT`` and/or ``STDERR``.
class IOLogger < IO
  autoload(:Logger, 'logger')

  # @param [String] file
  def initialize(file)
    @logger = Logger.new(file)
  end

  # @param [String] message
  def write(message)
    logger.info(message)

    nil
  end

  # @return [False]
  def tty?
    false
  end

  alias puts write

  alias isatty tty?

  protected

  attr_accessor :logger
end

# Depends on ``FCGI_LOGDIR`` to determine path for IOs (stdout, stderr) logdir.
if __FILE__ == $PROGRAM_NAME
  Pathname.new(ENV.fetch('FCGI_LOGDIR')).tap do |logdir|
    [:stdout, :stderr].each do |io|
      logdir.join("#{io}.log").tap do |file|
        "$#{io} = IOLogger.new(#{file.to_s.inspect})".tap do |script|
          self.instance_eval(script, __FILE__, __LINE__)
        end
      end
    end
  end

  Dir.chdir(__dir__) do
    Rack::FastCGI.new do
      WebApp.mount!(self)
    end.tap do |builder|
      Rack::Handler::FastCGI.run(builder)
    end
  end
end
