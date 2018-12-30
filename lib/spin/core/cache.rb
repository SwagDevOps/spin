# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../core'
require 'forwardable'

# Cache
class Spin::Core::Cache
  autoload(:Moneta, 'moneta')

  attr_reader :storage

  extend Forwardable

  def_delegators(:storage,
                 :[]=,
                 :clear,
                 :close,
                 :create,
                 :decrement,
                 :delete,
                 :expires,
                 :features,
                 :fetch,
                 :increment,
                 :key?,
                 :load,
                 :prefix,
                 :raw,
                 :store,
                 :supports?,
                 :with)

  def initialize(name, options = {})
    @storage = Moneta.new(name, options)
  end

  def cache(key)
    return storage[key] if storage.key?(key)

    storage[key] = yield
  end

  protected

  attr_writer :storage
end
