# frozen_string_literal: true

require_relative '../spin'

# Provides dynamic contant ``ENTRY_CLASS``.
#
# Sample of use:
#
# ```ruby
# class ParentClass
#   extend(EntryClass)
# end
# ```
module Spin::EntryClass
  def entry_class
    @@entry_class || self
  end

  def const_missing(name)
    if self.const_defined?(name)
      return self.public_send(name.to_s.downcase)
    end

    super
  end

  # @param [Symbol|String} name
  # @return [Boolean]
  def const_defined?(name)
    # rubocop:disable Style/TernaryParentheses
    (name.to_sym == :ENTRY_CLASS) ? true : super
    # rubocop:enable Style/TernaryParentheses
  end

  protected

  # @return [Class]
  def setup_entry_class!
    # rubocop:disable Style/ClassVars
    @@entry_class ||= Object.const_get("::#{self.name}")
    # rubocop:enable Style/ClassVars
  end
end
