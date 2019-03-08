# frozen_string_literal: true

require_relative '../spin'

# Namespace for core
module Spin::Core
  # @formatter:off
  {
    Autoloadable: :autoloadable,
    Cache: :cache,
    Config: :config,
    Container: :container,
    Forwardable: :forwardable,
    Html: :html,
    Http: :http,
    Initializer: :initializer,
    Injectable: :injectable,
    Setup: :setup,
  }.each { |k, v| autoload(k, "#{__dir__}/core/#{v}") }
  # @formatter:on
end
