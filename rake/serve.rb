# frozen_string_literal: true

# Sample of use:
#
# ```sh
# rake serve
# rake serve[environment] # default uses APP_ENV
# rake serve[environment] serve_port=80 serve_storage=/tmp/serve.$(id -u)
# ```

env = lambda do |key, default = nil|
  Pathname.new(__FILE__).basename('.rb').tap do |prefix|
    return ENV.fetch("#{prefix}_#{key}", default)
  end
end

storage = Pathname.new(env.call('storage', "#{Dir.pwd}/serve"))

# @formatter:off
engines = {
  unicorn: lambda do
    [
      'unicorn', '-c', "#{__FILE__.gsub(/\.rb$/, '')}/unicorn.rb",
      '--env', (ENV['APP_ENV'] || 'production')
    ]
  end
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

      opts[:cmd] = Shellwords.join(opts[:cmd])
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
    runner.call(engines.fetch(:unicorn).call)
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
