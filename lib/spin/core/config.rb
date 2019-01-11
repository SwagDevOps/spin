# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../core'
require 'tty/config'

# Reader for config
class Spin::Core::Config
  include Spin::Core::Injectable

  inject(:paths)

  # @formatter:off
  {
    Cache: :cache,
    Loader: :loader,
    Path: :path,
  }.each { |k, v| autoload(k, "#{__dir__}/config/#{v}") }
  # @formatter:on

  autoload(:IceNine, 'ice_nine')
  autoload(:OpenStruct, 'ostruct')

  # @return [Path]
  attr_reader :paths

  # @option options [Array<String>] :paths
  def initialize(**options)
    self.paths = options.fetch(:paths, [])
    self.cache = Cache.new
  end

  # Get value for given key.
  #
  # @param [String] key
  #
  # @return [OpenStruct|Object|nil]
  def get(key)
    base = key.to_s.split('.').first
    call = key.to_s.split('.')[1..-1].join('&.')

    self.read(base).tap do |s|
      return s if s.nil? || call.empty?

      return s.instance_eval(call)
    end
  end

  alias_method '[]', 'get'

  def to_a
    self.paths.to_a
  end

  protected

  # @type [Cache]
  # @return [Cache{Symobol => OpenStruct}]
  attr_accessor :cache

  def paths=(paths)
    @paths = Path.new(paths)
  end

  # @param [String] base
  #
  # @return [Spin::ConfigReader::Loader|nil]
  def read(base)
    self.load_as(base)
  end

  # Load given filename.
  #
  # @raise [ArgumentError]
  # @param [String|Symbol] filename
  #
  # @return [Spin::ConfigReader::Loader]
  def load_as(filename)
    unless Pathname.new(filename).basename.to_s == filename
      raise ArgumentError, filename
    end

    unless cache.key?(filename)
      load_file(filename).tap do |loaded|
        cache[filename] = self.class.__send__(:to_recursive_ostruct, loaded)
      end
    end

    cache.fetch(filename)
  end

  # @param [String|Symbol] filename
  #
  # @return [Hash]
  def load_file(filename)
    Loader.new(filename).tap do |loaded|
      self.paths.reverse_each do |path|
        begin
          loaded = loaded.merge(Loader.new(filename, path).to_h)
        rescue TTY::Config::ReadError
          next
        end
      end

      return loaded
    end
  end

  class << self
    protected

    # Transform given ``Hash`` to ``OpenStruct`` recursively.
    #
    # @param [Hash] input
    # @return [OpenStruc]
    def to_recursive_ostruct(input, frozen: true)
      input = input.to_h

      OpenStruct.new(input.each_with_object({}) do |(key, val), h|
        h[key.to_sym] = val.is_a?(Hash) ? __send__(__callee__, val) : val
      end).tap do |struct|
        IceNine.deep_freeze(struct) if frozen
      end
    end
  end
end
