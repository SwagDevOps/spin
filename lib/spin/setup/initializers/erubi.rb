# frozen_string_literal: true

if Gem::Specification.find_all_by_name('erubi').any?
  require 'erubi'
end
