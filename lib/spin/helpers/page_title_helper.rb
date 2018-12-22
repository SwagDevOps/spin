# frozen_string_literal: true

require_relative '../helpers'

# Page Title helper
#
# Provides (simili) accessors to ``page_title``
module Spin::Helpers::PageTitleHelper
  def self.included(base)
    base.class_eval do
      base.set(:page_title, nil)
    end
  end

  # @param [String] page_title
  def page_title=(page_title)
    settings.page_title = page_title.nil? ? nil : page_title.to_s
  end

  # @return [String|nil]
  def page_title
    settings.page_title
  end
end
