# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'

# Setup loader
class Spin::Setup < Array
  autoload :Pathname, 'pathname'

  # @return [String]
  attr_reader :target

  # @param [Class] loader
  # @param [String] target
  # @param [Array<String|Pathname>] paths
  def initialize(loader, target, paths = [])
    @loader = loader
    @target = target

    # rubocop:disable Lint/ShadowingOuterLocalVariable
    paths.to_a.map { |fp| Pathname.new(fp) }.tap do |paths|
      self.push(*paths)
    end
    # rubocop:enable Lint/ShadowingOuterLocalVariable

    freeze
  end

  # Get path
  #
  # Get first path where given (as ``target``) setup is found.
  #
  # @return [Pathname|nil]
  def path
    self.map { |path| Dir.glob("#{path}/setup/*.rb") }
        .flatten
        .map { |path| Pathname.new(path) }
        .keep_if { |fp| fp.basename('.rb').to_s == target }
        .first&.dirname
  end

  # Get (loadable) files.
  #
  # @return [Array<Pathname>]
  def files
    self.path.tap do |path|
      return [] unless path

      return ["#{path}/#{target}.rb", "#{path}/#{target}/**/*.rb"]
             .map { |patt| Dir.glob(patt).sort }
             .flatten
    end
  end

  # Load all ``setup`` files.
  #
  # @return [self]
  def call
    self.tap do
      files.each { |file| self.load(file) }
    end
  end

  protected

  # Get loader.
  #
  # @return [Class]
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