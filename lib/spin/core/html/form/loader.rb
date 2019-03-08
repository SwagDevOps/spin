# frozen_string_literal: true

require_relative '../form'

# Loader loading form templates.
class Spin::Core::Html::Form::Loader
  autoload(:Pathname, 'pathname')

  # @type [Array<Pathname>]
  attr_reader :paths

  # @param [Array<String>] paths
  def initialize(paths)
    self.paths = paths
  end

  # @param [Array] structure
  # @param [String] filepath
  #
  # @return [Array]
  def call(structure, filepath)
    content = Pathname.new(resolve(filepath).realpath).read

    # @formatter:off
    Array.new(structure)
         .instance_eval(content, Pathname.new(filepath).to_s, 1)
         .freeze
    # @formatter:on
  end

  protected

  # @param [String] filepath
  #
  # @return [Pathname]
  def resolve(filepath)
    Pathname.new(filepath).tap do |fp|
      return fp if fp.absolute?

      self.paths.each do |path|
        path.join("#{fp.to_s.gsub(/\.rb/, '')}.rb").tap do |rp|
          return rp if rp.file? and rp.readable?
        end
      end
    end
  end

  # @param [Array<String>] paths
  def paths=(paths)
    @paths = paths.map { |path| Pathname.new(path) }
  end
end
