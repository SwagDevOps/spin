# frozen_string_literal: true

# @see https://github.com/hanami/helpers
require 'hanami/helpers'

# rubocop:disable Style/MixinUsage
if Gem::Specification.find_all_by_name('hanami-helpers').any?
  include(Hanami::Helpers)
end

include(Spin::Helpers)
# rubocop:enable Style/MixinUsage
