# frozen_string_literal: true

lambda do
  require_relative 'dev/web_app'

  WebApp.new.controller_class.mount!
end.tap { |handler| run(handler.call) }
