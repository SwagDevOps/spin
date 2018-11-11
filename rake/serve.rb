# frozen_string_literal: true

# Sample of use:
#
# ```sh
# rake serve
# rake serve[shotgun] # default
# rake serve[puma]
# ```
desc 'Serve'
task :serve, [:engine] do |task, args|
  task.reenable

  [(args[:engine] || 'shotgun').to_s,
   '--port', ENV.fetch('SERVE_PORT', '9393')].tap do |command|
    # rubocop:disable Lint/HandleExceptions
    begin
      sh(*command, verbose: false)
    rescue Interrupt
    end
    # rubocop:enable Lint/HandleExceptions
  end
end
