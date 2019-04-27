# frozen_string_literal: true

Dir.chdir(__dir__) do
  require_relative 'dev/web_app'

  WebApp.run!(self)
end
