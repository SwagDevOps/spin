# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)
require_relative '../lib/spin'

# Sample web app to highlight inheritance.
class WebApp < Spin
  {
    Controller: :controller,
    Forms: :forms,
    User: :user,
  }.each { |k, v| autoload k, "#{__dir__}/web_app/#{v}" }

  class << self
    # @return [WebApp::Controller]
    def mount!
      self.new.container[:controller_class].mount!
    end

    def paths
      [Pathname.new(Dir.pwd),
       Pathname.new(__FILE__.gsub(/\.rb$/, '')),
       super.last].map(&:freeze)
    end
  end
end
