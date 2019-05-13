# frozen_string_literal: true

app = lambda do
  require_relative '../dev/web_app'

  WebApp.controller
end

base_routing = lambda do |c, base = '/'|
  require 'pathname'

  {}.tap do |routes|
    # @formatter:off
    c.ancestors
     .keep_if { |klass| klass.respond_to?(:routes) }
     .map(&:routes)
     .flatten.keep_if { |h| h.is_a?(Hash) and !h.empty? }
     .each do |h|
      h.each do |method, r|
        r.each do |ir|
          ir.first.to_s.gsub(%r{^/}, '').tap do |uri|
            next if uri =~ %r{^__sinatra__/}

            routes[uri] = {
              URI: Pathname.new(base.to_s).join(uri).to_s,
              methods: [method],
              path: base,
              controller: c,
            }.merge(routes[uri] || {})

            routes[uri][:methods].push(method).uniq!
          end
        end
      end
    end
  end
  # @formatter:on
end

routing = lambda do
  app.call.routing.map { |base, c| base_routing.call(c, base).values }.flatten
end

routing_task = lambda do
  require 'tty-table'

  routing.call.tap do |routes|
    unless routes.empty?
      routes.map! do |row|
        row.tap do
          # @formatter:off
          {
            methods: row[:methods].join(', '),
            controller: row[:controller].name.gsub(/^#{app.call.name}::/, '')
          }.tap { |o| row.merge!(o) }
          # @formatter:on
        end
      end

      routes[0].keys.map { |t| t.to_s.sub(/\w/, &:capitalize) }.tap do |headers|
        TTY::Table.new(headers, routes.map(&:values)).tap do |table|
          table.render(:ascii) do |renderer|
            renderer.padding = [0, 1, 0, 1]
          end.tap { |t| $stdout.puts(t) }
        end
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
