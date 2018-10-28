# frozen_string_literal: true

require_relative 'base'

# Home controller
class Spin::Controller::Home < Spin::Controller::Base
  get '/' do
    erb(:welcome)
  end
end
