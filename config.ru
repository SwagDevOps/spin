# frozen_string_literal: true

lambda do
  require_relative 'lib/spin'

  Spin.controller
end.tap { |handler| run(handler.call) }
