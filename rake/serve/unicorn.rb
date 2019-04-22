# frozen_string_literal: true

# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

require 'pathname'

env = lambda do |key, default = nil|
  Pathname.new(__FILE__).basename('.rb').tap do |prefix|
    return ENV.fetch("#{prefix}_#{key}", default)
  end
end

storage = Pathname.new(env.call('storage', "#{Dir.pwd}/serve"))

# Set path for logging
stdout_path storage.join('stdout.log').to_s
stderr_path storage.join('stderr.log').to_s

# Set unicorn options
listen env.call('port', 9393)
worker_processes env.call('threads', (`nproc`.to_i * 2)).to_i
preload_app false
worker_exec true
timeout 30
default_middleware false
check_client_connection true

after_worker_ready do |server, worker|
  server.logger.info("worker #{worker.nr} ready")
end

after_worker_exit do |server, worker, status|
  # status is a Process::Status instance for the exited worker process
  unless status.success?
    server.logger.error("worker process failure: #{status.inspect}")
  end
end
