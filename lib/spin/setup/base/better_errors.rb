# frozen_string_literal: true

if Gem::Specification.find_all_by_name('better_errors').any?
  configure :development do
    require 'better_errors'

    use BetterErrors::Middleware
    BetterErrors.maximum_variable_inspect_size = 100_000

    # set application root
    BetterErrors.application_root = File.expand_path(root)
  end

  if Gem::Specification.find_all_by_name('binding_of_caller').any?
    require 'binding_of_caller'
  end
end
