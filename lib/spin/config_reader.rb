# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'
require 'tty/config'

# Reader for config
class Spin::ConfigReader < Array
  # @formatter:off
  {
    Cache: :cache,
    Loader: :loader,
  }.each { |k, v| autoload(k, "#{__dir__}/config_reader/#{v}") }
  # @formatter:on

  # @param [Array<String>] paths
  def initialize(paths)
    paths.to_a.each do |path|
      ENV['APP_ENV'].tap do |env|
        self.push(Pathname.new(path).join(env)) if env
      end

      self.push(Pathname.new(path))
    end

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

  protected

  # @type [Cache]
  # @return [Cache{Symobol => OpenStruct}]
  attr_accessor :cache

  # @param [String] base
  #
  # @return [Spin::ConfigReader::Loader|nil]
  def read(base)
    self.load_as(base)
  rescue TTY::Config::ReadError
    nil
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
      cache[filename] = Loader.new(self, filename).to_recursive_ostruct
    end

    cache.fetch(filename)
  end
end
