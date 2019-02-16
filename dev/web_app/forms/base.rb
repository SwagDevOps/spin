# frozen_string_literal: true

require_relative '../forms'

# Base form (with attributes).
#
# @abstract
class WebApp::Forms::Base < Spin::Core::Html::Form
  def initialize(*args)
    super

    self.attributes = { class: 'mdl-card__supporting-text' }
  end
end
