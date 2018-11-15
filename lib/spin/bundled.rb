# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# rubocop:disable Style/Documentation

require_relative '../spin'

class Spin
  class << self
    # Denote use of ``Bundler`` (vendoring).
    #
    # @return [Boolean]
    def bundled?
      return false if ENV['BOHU_BUNDLED'] == 'false'

      Dir.chdir("#{__dir__}/../..") do
        [['gems.rb', 'gems.locked'], ['Gemfile', 'Gemfile.lock']]
          .map { |m| 2 == Dir.glob(m).size }
          .include?(true)
      end
    end
  end
end

# rubocop:enable Style/Documentation

if Spin.bundled?
  %w[rubygems bundler/setup].each { |req| require req }

  if Gem::Specification.find_all_by_name('kamaze-project').any?
    require 'kamaze/project/core_ext/pp'
  end
end
