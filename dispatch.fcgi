#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'dev/web_app'
require 'rack'
require 'uri'
require 'logger'
require 'pathname'

# Wrapper around a Rack app to fix some environment variables.
#
# Fix:
#
#  * SCRIPT_NAME
#  * PATH_INFO
#  * QUERY_STRING
class Rack::AppWrapper
  # @param [Rack::Builder] app
  def initialize(app)
    self.app = app
  end

  def call(env)
    URI(env.fetch('REQUEST_URI')).tap do |uri|
      env['SCRIPT_NAME'] = '/'
      env['PATH_INFO'] = uri.path
      env['QUERY_STRING'] = uri.query
    end

    app.call(env)
  end

  protected

  attr_accessor :app
end

# Provide a logger built into an IO to replace ``STDOUT`` and/or ``STDERR``
class IOLogger < IO
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

if __FILE__ == $PROGRAM_NAME
  [:stdout, :stderr].each do |io|
    Pathname.new(ENV.fetch('FCGI_LOGDIR')).join("#{io}.log").tap do |file|
      ('$%<io>s = IOLogger.new("%<file>s")' % {
        io: io,
        file: file,
      }).tap do |script|
        self.instance_eval(script, __FILE__, __LINE__)
      end
    end
  end

  Dir.chdir(__dir__) do
    builder = Rack::Builder.new do
      WebApp.mount!(self)
    end

    Rack::Handler::FastCGI.run(Rack::AppWrapper.new(builder))
  end
end
