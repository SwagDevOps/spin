# frozen_string_literal: true

# rubocop:disable Style/MixinUsage
if Gem::Specification.find_all_by_name('better_errors').any?
  configure :development do
    require 'better_errors'

    use BetterErrors::Middleware
    BetterErrors.maximum_variable_inspect_size = 100_000

    # you need to set the application root in order to abbreviate filenames
    # within the application:
    BetterErrors.application_root = File.expand_path(root)
  end
end

include(Spin::Helpers)
# rubocop:enable Style/MixinUsage
