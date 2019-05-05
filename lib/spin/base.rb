# frozen_string_literal: true

require_relative '../spin'
require 'sinatra/base'

# @abstract
#
# @see https://github.com/sinatra/sinatra/blob/ba63ae84bd52174af03d3933863007ca8a37ac1c/lib/sinatra/base.rb#L904
class Spin::Base < Sinatra::Base
  # @api private
  #
  # @type [Spin::Container]
  @container = nil

  # @type [Spin::Core::Config]
  @config = nil

  def call(env)
    env['SCRIPT_NAME'] = ''

    super(env)
  end

  class << self
    protected

    # Container acessor.
    #
    # Container is set during the ``setup`` phase,
    # it SHOULD NOT be used for any other purpose.
    #
    # @return [Spin::Core::Container]
    attr_accessor :container

    # @return [Spin::Core::Config]
    attr_writer :config

    # @return [Spin::Core::Config]
    def config
      @config || (container || {})[:config]
    end
  end
end
