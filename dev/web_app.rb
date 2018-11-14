# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)
require_relative '../lib/spin'

# Sample web app to highlight inheritance.
class WebApp < Spin
  {
    Controller: :controller,
    User: :user,
  }.each { |k, v| autoload k, "#{__dir__}/web_app/#{v}" }

  class Base < Spin::Base
    # Avoid to pollute original class
  end

  class << self
    def paths
      [Pathname.new(Dir.pwd),
       Pathname.new(__FILE__.gsub(/\.rb$/, '')),
       super.last].map(&:freeze)
    end
  end
end
