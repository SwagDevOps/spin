# frozen_string_literal: true

require_relative './base'

# Class for pages
class WebApp::Controller::Pages < WebApp::Controller::Base
  get(%r{/(.+)}) do
    self.render_page(params[:captures][0])
  end

  protected

  def render_page(path)
    erb("pages/#{path}".to_sym)
  rescue Errno::ENOENT => e
    logger.debug("#{__FILE__}:#{__LINE__ - 2}: #{e.message}")

    halt(404)
  end
end
