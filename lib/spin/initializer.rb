# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'

# Initializers loader
#
# After it loads the framework plus any gems and plugins,
# ``Spin`` turns to loading initializers.
# An initializer is any file of ruby code stored under ``initializers``
# in your application.
# You can use initializers to hold configuration settings
# that should be made after all of the frameworks and plugins are loaded.
class Spin::Initializer < Array
  autoload :Pathname, 'pathname'

  # @param [Array<String|Pathname>] paths
  def initialize(paths = [])
    # rubocop:disable Lint/ShadowingOuterLocalVariable
    paths.to_a.map { |fp| Pathname.new(fp) }.tap do |paths|
      self.push(*paths)
    end
    # rubocop:enable Lint/ShadowingOuterLocalVariable

    freeze
  end

  # @return [Array<Pathname>]
  def files
    self.map { |path| Dir.glob("#{path}/*.rb") }
        .flatten
        .map { |path| Pathname.new(path) }
  end

  # Get items (initializers).
  #
  # Get paths indexed
  #
  # @return [Hash{Symbol => Pathname}]
  def items
    {}.tap do |items|
      files.each do |fp|
        unless items.key?(k = fp.basename('.*').to_s.to_sym)
          items[k] = fp
        end
      end
    end.sort.to_h
  end

  # Require all items
  #
  # @return [Array<Pathname>]
  def call
    items.values.each { |fp| require(fp) }
  end
end
