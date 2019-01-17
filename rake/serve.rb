# frozen_string_literal: true

# Sample of use:
#
# ```sh
# rake serve
# rake serve[environment] # default (uses APP_ENV)
# ```
desc 'Serve'
task :serve, [:environment] do |task, args|
  engine = :puma
  env = (args[:environment] || ENV['APP_ENV'] || 'production').to_s
  # @formatter:off
  paths = ['lib', 'dev', 'setup', 'config', 'vendor']
          .map { |fp| Pathname.new(fp) }
          .keep_if(&:directory?)
  # @formatter:on

  [{ 'APP_ENV' => env }, 'rerun', '--dir', paths.join(','),
   '--verbose',
   '--no-notify',
   "#{engine} --port=9393 -R config.ru"].tap do |command|
    begin
      sh(*command, verbose: false)
    rescue Interrupt
      task.reenable
    else
      task.reenable
    end
  end
end
