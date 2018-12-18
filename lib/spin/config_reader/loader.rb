# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../config_reader'
require 'tty/config'

# Config reader
class Spin::ConfigReader::Loader < TTY::Config
  autoload(:Erb, 'erb')
  autoload(:OpenStruct, 'ostruct')
  autoload(:Pathname, 'pathname')
  autoload(:IceNine, 'ice_nine')

  attr_reader :paths

  def initialize(paths, filename, settings = {})
    super(settings)

    @read_count = 0
    self.filename = filename

    @paths = paths.map { |path| Pathname.new(path) }
    self.paths.each { |path| self.append_path(path) }
  end

  def read(*)
    super.tap do
      @read_count += 1
    end
  end

  def read?
    @read_count >= 1
  end

  def to_h
    read unless self.read?

    super
  end

  # @return [OpenStruct]
  def to_recursive_ostruct(frozen: true)
    self.class.__send__(:to_recursive_ostruct, self.to_h, frozen: frozen)
  end

  def fetch(*args)
    self.to_h.fetch(*args)
  end

  def [](key)
    self.to_h[key]
  end

  def each(&block)
    to_h.each(&block)
  end

  # @api private
  def unmarshal(file, format: :auto)
    erb(super)
  end

  protected

  # @param [Object] input
  # @return [Object]
  def erb(input)
    input.tap do
      return ERB.new(input).result if input.is_a?(String)

      if input.is_a?(Hash)
        return input.map { |k, v| [k, __send__(__callee__, v)] }.to_h
      end

      if input.is_a?(Array)
        return input.map { |v| __send__(__callee__, v) }
      end
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
