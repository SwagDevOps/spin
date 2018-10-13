# frozen_string_literal: true

require_relative '../spin'

# Base controller
#
# Used for autoloading.
#
# @abstract
class Spin::Controller < Sinatra::Base
  {
    Home: :home,
  }.each { |k, v| autoload k, "#{__dir__}/controller/#{v}" }
end
