# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require_relative 'lib/spin'

run(Spin.controller)
