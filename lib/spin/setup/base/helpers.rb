# frozen_string_literal: true

# rubocop:disable Style/MixinUsage
if Gem::Specification.find_all_by_name('hanami-helpers').any?
  # @see https://github.com/hanami/helpers
  require 'hanami/helpers'

  include(Hanami::Helpers)
end

include(Spin::Helpers)
# rubocop:enable Style/MixinUsage
