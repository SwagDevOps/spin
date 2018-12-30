# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../config'

# Array of paths
class Spin::Core::Config::Path < Array
  # @param [Array<String>] paths
  def initialize(paths)
    paths.to_a.each do |path|
      ENV['APP_ENV'].tap do |env|
        self.push(Pathname.new(path).join(env)) if env
      end

      self.push(Pathname.new(path))
    end
  end
end
