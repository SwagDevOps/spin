# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../initializer'

# Loader
#
# @see https://guides.rubyonrails.org/v2.3/configuring.html#using-initializers
class Spin::Initializer::Loader < Array
  # @param [Spin::Container] container
  def initialize(container)
    @container = container

    super([])
  end

  # Adds a block which will be executed after been fully initialized.
  #
  # Useful for per-environment configuration which depends on
  # the framework being fully initialized.
  def after_initialize(&block)
    self.push(block)
  end

  protected

  # @return [Spin::Container]
  attr_reader :container
end
