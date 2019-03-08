# frozen_string_literal: true

require_relative './base'

# Login form
class WebApp::Forms::Login < WebApp::Forms::Base
  def initialize(*args)
    super

    self.url = '/login'
  end

  push(lambda do |_f|
    [[:username, :text_field, 'Username'],
     [:password, :password_field, 'Password']].each do |name, type, label|
      div do
        label(name) { label }
        public_send(type, name, required: true)
      end
    end
  end, lambda do |_f|
    div { submit('Submit') }
  end)
end
