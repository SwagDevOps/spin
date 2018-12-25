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
    url_fragment = url_fragment.gsub(%r{^/}, '')
    ports = [['http', 80], ['https', 443]]
    # @formatter:off
    parts = [
      request.scheme, '://', request.host,
      { true => ":#{request.port}",
        false => nil }[!ports.include?([request.scheme, request.port])],
      request.script_name
    ][(path_only ? -1 : 0)..-1]
    # @formatter:on

    "#{parts.join('')}/#{url_fragment}"
  end
end
