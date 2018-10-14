# frozen_string_literal: true

require_relative '../spin'
require 'sinatra/base'

# @abstract
class Spin::Base < Sinatra::Base
  class << self
    protected

    # @return [Spin::Config]
    def config(*args)
      Spin.__send__(:config, *args)
    end
  end
end
