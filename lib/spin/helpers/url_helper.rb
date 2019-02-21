# frozen_string_literal: true

require_relative '../helpers'

# Url helper
module Spin::Helpers::UrlHelper
  # Construct a link to +url_fragment+
  #
  # Link SHOULD be given relative to the base of this Sinatra app.
  # # <code>path_only</code>, which will generate an absolute path within
  # the current domain (the default), or <code>:full_url</code>, which will
  # include the site name and port number.  The latter is typically necessary
  # for links in RSS feeds.
  def url_for(url_fragment, path_only: true)
    Spin::Core::Http::Url.new(url_fragment) do |url|
      url.path_only = path_only
      url.request = self.request
    end
  end
end
