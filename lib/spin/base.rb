# frozen_string_literal: true

require_relative '../spin'
require 'sinatra/base'

# @abstract
#
# @see https://github.com/sinatra/sinatra/blob/ba63ae84bd52174af03d3933863007ca8a37ac1c/lib/sinatra/base.rb#L904
class Spin::Base < Sinatra::Base
  # @type [Spin::Container]
  @container = nil

  # @type [Spin::Core::Config]
  @config = nil

  class << self
    protected

    # @return [Spin::Core::Container]
    attr_accessor :container

    # @return [Spin::Core::Config]
    attr_writer :config

    # @return [Spin::Core::Config]
    def config
      @config || container[:config]
    end
  end
end
