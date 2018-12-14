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
    paths.to_a.each { |path| self.push(Pathname.new(path)) }

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
  # @return [Cache]
  attr_accessor :cache

  # @param [String] base
  #
  # @return [Spin::ConfigLoader]
  def read(base)
    self.load_as(base).to_recursive_ostruct
  rescue TTY::Config::ReadError
    nil
  end

  # @return [Spin::ConfigLoader]
  def load_as(base)
    unless cache.key?(base)
      cache[base] = Loader.new(self, base)
    end

    cache.fetch(base)
  end
end
