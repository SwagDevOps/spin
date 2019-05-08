# frozen_string_literal: true

app = lambda do
  require_relative '../dev/web_app'

  WebApp.controller
end

routing = lambda do
  require 'tty-table'
  require 'pathname'

  app.call.routing.map do |base, c|
    c.routes.map do |method, routes|
      routes.map { |r| r.first.to_s }.map do |route|
        # @formatter:off
        {
          URI: Pathname.new(base.to_s).join(route.to_s.gsub(%r{^/}, '')).to_s,
          controller: c,
          path: base,
          method: method,
        }
        # @formatter:on
      end
    end
  end.flatten
end

routing_task = lambda do
  routing.call.tap do |r|
    [r[0] ? r[0].keys.map { |t| t.to_s.sub(/\w/, &:capitalize) } : [],
     r.map(&:values)].tap do |v|
      TTY::Table.new(v[0].to_a, v[1]).tap do |table|
        table.render(:ascii) do |renderer|
          renderer.padding = [0, 1, 0, 1]
        end.tap { |t| $stdout.puts(t) }
      end
    end
  end
end

# task --------------------------------------------------------------

desc 'Routes'
task :routes do |task|
  routing_task.call

  task.reenable
end
