# frozen_string_literal: true

require_relative '../controller'

# Home controller
class Spin::Controller::Home < Spin::Base
  get '/' do
    erb(:welcome)
  end
end
