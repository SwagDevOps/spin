# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'
require 'tty/config'
require 'erb'
require 'pathname'

# Config reader
class Spin::Config < TTY::Config
  def initialize(settings = {})
    super(settings)
    @read_count = 0
    self.filename = :config
    self.prepare_env

    self.class.paths.each do |path|
      self.append_path(path)
    end
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
    read unless read?

    super
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

  def prepare_env
    # ``LIBDIR`` absolute path inside current ``lib``
    ENV['LIBDIR'] = Pathname.new(__FILE__).realpath.dirname.to_path
  end

  class << self
    def paths
      [Dir.pwd, Pathname.new(__dir__).to_path]
    end
  end
end
