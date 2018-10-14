# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'
require 'tty/config'
require 'forwardable'

# Config reader
class Spin::Config < TTY::Config
  def initialize(filename = :config, settings = {})
    super(settings)
    @read_count = 0
    self.filename = filename.to_s

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

  class << self
    def paths
      [
        "#{Dir.pwd}/config",
        Pathname.new(__dir__).join('..', '..', 'config').realpath.to_path
      ]
    end
  end
end
