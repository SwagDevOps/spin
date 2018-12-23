# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../config_reader'
require 'forwardable'
require 'tty/config'

# Config reader
class Spin::ConfigReader::Loader < TTY::Config
  autoload(:Erb, 'erb')
  autoload(:Pathname, 'pathname')

  attr_reader :paths

  extend Forwardable

  def_delegators(:to_h, :each, :'[]', :fetch)

  def initialize(filename, *paths, **settings)
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

  def merge(other_settings)
    # avoid to raise ``TypeError`` from an empty file

    super(other_settings.nil? ? {} : other_settings)
  end

  def to_hash
    read unless self.read?

    super
  end

  alias to_h to_hash

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
end
