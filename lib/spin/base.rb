# frozen_string_literal: true

require_relative '../spin'
require 'sinatra/base'

# @abstract
#
# @see https://github.com/sinatra/sinatra/blob/ba63ae84bd52174af03d3933863007ca8a37ac1c/lib/sinatra/base.rb#L904
class Spin::Base < Sinatra::Base
  def authenticate!
    env.fetch('warden').authenticate!
  end

  class << self
    protected

    # @return [Spin::Config]
    def config(*args)
      # rubocop:disable Style/GlobalVars
      $ENTRY_CLASS.__send__(:config, *args)
      # rubocop:enable Style/GlobalVars
    end
  end
end
