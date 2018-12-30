# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../config'

# Cache for config
class Spin::Core::Config::Cache < Hash
  def initialize
    super
  end

  def key?(key)
    super(key.to_sym)
  end

  def []=(key, value)
    super(key.to_sym, value)
  end

  def fetch(*args)
    args[0] = args.fetch(0).to_sym

    super(*args)
  end
end
