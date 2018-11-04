# frozen_string_literal: true

enable(:sessions)

{
  key: ENV.fetch('SESSION_KEY', 'unicorn.session'),
  path: ENV.fetch('SESSION_PATH', '/'),
  domain: ENV['SESSION_DOMAIN'],
  expire_after: ENV.fetch('SESSION_EXPIRE_AFTER', 2_592_000).to_i,
  secret: ENV.fetch('SESSION_SECRET'),
  old_secret: ENV['SESSION_OLD_SECRET'],
}.delete_if { |k, v| v.to_s.empty? }.tap do |settings|
  set(:sessions, settings)
end
