# frozen_string_literal: true

require_relative '../helpers'

# Erb include helper
module Spin::Helpers::ViewEvalHelper
  autoload(:Pathname, 'pathname')

  # Eval content of the given filepath (relative do views dir) in context.
  #
  # @param [String] path
  # @param [Object] context
  #
  # @see https://github.com/hanami/helpers
  # @see https://github.com/hanami/helpers/blob/master/lib/hanami/helpers/html_helper/html_builder.rb#L236
  #
  # @return [Hanami::Helpers::HtmlHelper::HtmlBuilder]
  def view_eval(path, context = nil)
    context ||= self

    if context.respond_to?(:settings) and context.settings.respond_to?(:views)
      views_dir = context.settings.views
    else
      views_dir = settings.views
    end

    Pathname.new(views_dir).join("#{path}.rb").tap do |inc|
      return context.instance_eval(inc.read, inc.to_s, 1)
    end
  end
end
