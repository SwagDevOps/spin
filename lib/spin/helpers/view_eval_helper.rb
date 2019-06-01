# frozen_string_literal: true

require_relative '../helpers'

# Erb include helper
module Spin::Helpers::ViewEvalHelper
  autoload(:Digest, 'digest')
  autoload(:Pathname, 'pathname')

  protected

  # Eval content of the given filepath (relative do views dir) in context.
  #
  # @param [String] path
  # @param [Hash] variables
  #
  # @see https://github.com/hanami/helpers
  # @see https://github.com/hanami/helpers/blob/master/lib/hanami/helpers/html_helper/html_builder.rb#L236
  #
  # @return [Hanami::Helpers::HtmlHelper::HtmlBuilder]
  def view_eval(path, variables = {})
    view_eval_vars(path, variables).tap do |lines|
      Pathname.new(self.settings.views).join("#{path}.rb").tap do |inc|
        lines.clone.push(inc.read).join("\n").tap do |content|
          return self.instance_eval(content, inc.to_s, 1 - lines.size)
        end
      end
    end
  end

  # @param [String] path
  # @param [Hash] variables
  #
  # @return [String]
  def view_eval_store(path, variables = {})
    Digest::SHA256.hexdigest(path.to_s).tap do |key|
      @view_eval_store ||= {}
      @view_eval_store[key] = variables.clone.freeze
    end
  end

  # @param [String] path
  # @param [Hash] variables
  #
  # @return [Array<String>]
  def view_eval_vars(path, variables = {})
    return [] if variables.empty?

    ['# frozen_string_literal: true'].tap do |lines|
      view_eval_store(path, variables).tap do |key|
        variables.each_key do |k|
          lines.push(" #{k}= @view_eval_store[#{key.inspect}][#{k.inspect}]")
        end
      end
    end
  end
end
