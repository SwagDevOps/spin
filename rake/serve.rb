# frozen_string_literal: true

# Sample of use:
#
# ```sh
# rake serve
# rake serve[environment] # default uses APP_ENV
# rake serve[environment] serve_port=80 serve_storage=/tmp/serve.$(id -u)
# ```
#
# If your app is not thread safe, you will only be able to use workers.
# Set your min and max threads to 1:
#
# ```
# serve_threads=1:1
# ```
# @see https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#config

require 'yaml'

env = lambda do |key, default = nil|
  Pathname.new(__FILE__).basename('.rb').tap do |prefix|
    return default unless ENV.key?("#{prefix}_#{key}")

    return YAML.safe_load(ENV.fetch("#{prefix}_#{key}"))
  end
end

storage = Pathname.new(env.call('storage', "#{Dir.pwd}/serve"))

# @formatter:off
engines = {
  puma: lambda do
    [
      'puma',
      '--port', env.call('port', 9393),
      '--restart-cmd', 'config.ru',
      '--log-requests',
      -> { env.call('log_requests', true) ? '--log-requests' : nil },
      -> { env.call('debug', false) ? '--debug' : nil },
      '--state', storage.join('state.yml'),
      '--redirect-stdout', storage.join('stdout.log'),
      '--redirect-stderr', storage.join('stderr.log'),
      '--environment', ENV.fetch('APP_ENV', 'production'),
      '--preload',
      '--threads', -> { env.call('threads', `nproc`.chomp) },
      '--workers', -> { env.call('workers', 2) },
    ]
  end,
}
# @formatter:on

# @see Rerun::Runner
runner = lambda do |command = nil|
  autoload(:Rerun, 'rerun')

  Rerun::Options.parse(config_file: '.rerun').tap do |opts|
    opts[:cmd] = nil if opts[:cmd] and opts[:cmd][0] == '#'
    opts[:cmd] ||= command
    if opts[:cmd].is_a?(Array)
      autoload(:Shellwords, 'shellwords')

      opts[:cmd] = Shellwords.join(opts[:cmd].map do |param|
        param.is_a?(Proc) ? param.call : param
      end.compact)
    end
  end.tap do |options|
    return nil if options.nil? or options[:cmd].nil? or options[:cmd].empty?

    return Rerun::Runner.keep_running(options[:cmd], options)
  end
end

fake_env = lambda do |environment, &block|
  backup = ENV.to_hash
  ENV.replace(environment)

  block.call
ensure
  ENV.replace(backup)
end

# task --------------------------------------------------------------

desc 'Serve'
task :serve, [:environment] do |task, args|
  # rubocop:disable Layout/ElseAlignment
  main = lambda do
    runner.call(engines.fetch(:puma).call)
  rescue Interrupt
    task.reenable
  else
    task.reenable
  end
  # rubocop:enable Layout/ElseAlignment

  FileUtils.mkdir_p(storage, verbose: true)
  storage.join("#{task.name}.pid").tap do |pid_file|
    raise "Already running (#{pid_file.read})" if pid_file.exist?

    pid_file.write(Process.pid)
    at_exit { FileUtils.rm_f(pid_file) }
    (args[:environment] || ENV['APP_ENV'] || 'production').to_s.tap do |app_env|
      fake_env.call(ENV.to_hash.merge('APP_ENV' => app_env)) do
        main.call
      end
    end

    FileUtils.rm_f(pid_file)
  end
end
