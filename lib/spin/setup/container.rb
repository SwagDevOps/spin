# frozen_string_literal: true

# @see https://dry-rb.org/gems/dry-container/

autoload(:Pathname, 'pathname')

self.register(:forms_paths, lambda do
  self[:paths].map { |fp| Pathname.new(fp).join('resources/forms') }
end, call: true)
