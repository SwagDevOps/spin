# frozen_string_literal: true

require_relative '../http'

# Url representation
#
# Sample of use:
#
# ```ruby
# url = WebApp::Core::Http::Url.new('sample/config/1') do |url|
#   url.request = OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
#   url.path_only = false
# end
#
# url.to_path
# # "/sample/config/1"
# url.to_url
# # "http://example.org//sample/config/1"
# ```
class Spin::Core::Http::Url
  autoload(:URI, 'uri')

  # @return [String]
  attr_reader :fragment

  # @type [Object]
  attr_accessor :request

  # @type [Boolean]
  attr_accessor :path_only

  # @param [String] fragment
  def initialize(fragment)
    @fragment = fragment.gsub(%r{^/}, '')
    @path_only = false

    yield(self) if block_given?
  end

  def path_only?
    !!@path_only
  end

  # Get path.
  #
  # @return [String]
  def to_path
    [request.script_name, fragment].join('/')
  end

  # Get URL.
  #
  # @return [String]
  def to_url
    ports = [['http', 80], ['https', 443]]
    # @formatter:off
    parts = [
      request.scheme, '://', request.host,
      { true => ":#{request.port}",
        false => nil }[!ports.include?([request.scheme, request.port])],
    ][(path_only? ? -1 : 0)..-1]
    # @formatter:on

    "#{parts.join('')}/#{to_path}"
  end

  # @return [URI::HTTP]
  def to_uri
    URI(to_url)
  end

  alias_method 'to_s', 'to_url'
end
