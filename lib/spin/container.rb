# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'
require 'dry/container'

# Container
#
# @see https://dry-rb.org/gems/dry-auto_inject/
class Spin::Container < Dry::Container
  extend Dry::Container::Mixin
end