# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../spin'

# Cache for config
module Spin::Injectable
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Class methods
  module ClassMethods
    protected

    # Inject given key.
    #
    # @return [Boolean]
    # @see https://dry-rb.org/gems/dry-auto_inject/
    def inject(key, strategy: :kwargs)
      # rubocop:disable Style/NilComparison
      return false if self.injector == nil

      # rubocop:enable Style/NilComparison

      !!self.__send__(:include, self.injector.__send__(strategy)[key])
    end

    # @return [Dry::AutoInject::Builder|nil]
    def injector
      $INJECTOR.tap do |injector|
        return nil if injector.nil?

        return injector.respond_to?(:call) ? injector.call : nil
      end
    end
  end
end
