# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)
require_relative '../lib/spin'

# Sample web app to highlight inheritance.
class WebApp < Spin
  # @formatter:off
  {
    Controller: :controller,
    Forms: :forms,
    User: :user,
  }.each { |k, v| autoload k, "#{__dir__}/web_app/#{v}" }
  # @formatter:on

  class << self
    # @param [Rack::Builder] builder
    #
    # @see Spin::Controller.run!()
    def run!(builder)
      self.new.container[:controller_class].tap do |controller|
        # @type []Spin::Controller} controller
        return controller.run!(builder)
      end
    end

    def paths
      [Pathname.new(Dir.pwd),
       Pathname.new(__FILE__.gsub(/\.rb$/, '')),
       super.last].map(&:freeze)
    end
  end
end
