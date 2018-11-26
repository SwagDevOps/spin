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
  autoload :Loader, "#{__dir__}/initializer/loader"

  # @param [Spin::Container] container
  def initialize(container)
    @loader = Loader.new(container)

    container[:paths].to_a.map { |fp| Pathname.new(fp) }.tap do |paths|
      self.push(*paths)
    end

    freeze
  end

  # @return [Array<Pathname>]
  def files
    self.map { |path| Dir.glob("#{path}/setup/initializers/*.rb") }
        .flatten
        .map { |path| Pathname.new(path) }
  end

  # Get items (initializers).
  #
  # Get indexed filepath for initializer files.
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

  # Load all items
  #
  # @see Loader#after_initialize
  #
  # @return [Array<Pathname>]
  def call
    self.tap do
      self.items.values.each { |fp| self.load(fp) }

      loader.each { |c| c.call(loader) }
    end
  end

  protected

  # @return [Loader]
  attr_reader :loader

  # Load given file.
  #
  # @param [String] file
  # @return [Loader]
  def load(file)
    content = Pathname.new(file).realpath.read

    self.loader.tap do |loader|
      loader.instance_eval(content, file.to_s, 1)
    end
  end
end
