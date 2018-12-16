# frozen_string_literal: true

require 'pathname'
require 'sham'
require_relative 'local'

Sham::Config.activate!(Pathname.new(__dir__).join('..').realpath)

Object.class_eval { include Local }

RSpec.configure do |rspec|
  # @see https://github.com/rspec/rspec-core/issues/2246
  rspec.around(:example) do |example|
    begin
      example.run
    rescue SystemExit => e
      raise "Unhandled SystemExit (#{e.status})"
    end
  end
end
