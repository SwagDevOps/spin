# frozen_string_literal: true

require_relative '../spin'

# Namespace for core
module Spin::Core
  # @formatter:off
  {
    Cache: :cache,
  }.each { |k, v| autoload(k, "#{__dir__}/core/#{v}") }
  # @formatter:on
end
