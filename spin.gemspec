# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# frozen_string_literal: true

# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "spin"
  s.version     = "0.0.1"
  s.date        = "2017-10-13"
  s.summary     = "Web app based on Sinatra"
  s.description = "Basic web app based on Sinatra"

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/spin"

  # MUST follow the higher required_ruby_version
  # requires version >= 2.3.0 due to safe navigation operator &
  s.required_ruby_version = ">= 2.3.0"
  s.require_paths = ["lib"]
  s.bindir        = "bin"
  s.executables   = Dir.glob([s.bindir, "/*"].join)
                       .select { |f| File.file?(f) and File.executable?(f) }
                       .map { |f| File.basename(f) }
  s.files = [
    ".yardopts",
    s.require_paths.map { |rp| [rp, "/**/*.rb"].join },
    s.require_paths.map { |rp| [rp, "/**/*.yml"].join },
  ].flatten
   .map { |m| Dir.glob(m) }
   .flatten
   .push(*s.executables.map { |f| [s.bindir, f].join("/") })

  s.add_runtime_dependency("sinatra", [">= 0"])
  s.add_runtime_dependency("bcrypt", [">= 0"])
  s.add_runtime_dependency("kamaze-version", [">= 0"])
  s.add_runtime_dependency("shotgun", [">= 0"])
  s.add_runtime_dependency("sqlite3", [">= 0"])
  s.add_runtime_dependency("thin", [">= 0"])
  s.add_runtime_dependency("tux", [">= 0"])
end

# Local Variables:
# mode: ruby
# End:
