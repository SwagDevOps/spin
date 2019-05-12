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
              controller: c,
              path: base,
              methods: [method],
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
  app.call.routing.map do |base, c|
    base_routing.call(c, base).values.map do |v|
      v.tap do
        v[:methods] = v[:methods].map(&:to_s).join(', ')
      end
    end
  end.flatten
end

routing_task = lambda do
  require 'tty-table'

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
