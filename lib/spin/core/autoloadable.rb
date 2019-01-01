# frozen_string_literal: true

require_relative '../core'
require 'dry/inflector'

# Provides automagic autoload.
module Spin::Core::Autoloadable
  class << self
    def included(base)
      base.extend(ClassMethods)
    end
  end

  # Class methods
  module ClassMethods
    protected

    # @param [Array] locations
    # @return [Array<String>]
    def autoload_glob(locations = caller_locations)
      locations.delete_if { |row| row[0] == __FILE__ }

      locations[0].fetch(0).gsub(/\.rb$/, '').tap do |path|
        return Dir.glob("#{path}/*.rb")
      end
    end

    # Get autoloadables ``{ 'CamelizedName' => 'filepath' }``.
    #
    # @return [Hash{String => String}]
    def autoloadables
      inf = Dry::Inflector.new

      autoload_glob
        .map { |f| [File.basename(f, '.rb'), f] }
        .map { |k, v| [inf.camelize(k), v] }
        .to_h
    end

    # @return [self]
    def autoload_self
      self.tap do
        autoloadables.each { |k, v| autoload(k, v) }
      end
    end
  end
end
