# frozen_string_literal: true

lambda do
  require_relative 'dev/web_app'

  WebApp.controller
end.tap { |handler| run(handler.call) }
