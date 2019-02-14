# frozen_string_literal: true

require_relative '../web_app'

# Namespace for forms
module WebApp::Forms
  {
    Login: :login,
  }.each { |k, v| autoload k, "#{__dir__}/forms/#{v}" }
end
