# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'

# Reader for config
class Spin::ConfigReader < Array
  # @param [Array<String>]
  def initialize(paths)
    paths.to_a.each { |path| self.push(Pathname.new(path)) }
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

  # @param [String] base
  #
  # @return [Spin::ConfigLoader]
  def read(base)
    Spin::ConfigLoader.new(self, base)&.to_recursive_ostruct
  rescue TTY::Config::ReadError
    nil
  end
end
