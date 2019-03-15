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

  # Base path used to construct URL.
  #
  # @return [String]
  attr_reader :path

  # Fragment identifier
  #
  # @see https://en.wikipedia.org/wiki/Fragment_identifier
  #
  # @return [String]
  attr_accessor :fragment

  # Original request (or forged using a struct).
  #
  # Request SHOULD (at least) provide the following methods:
  #
  # * ``scheme``
  # * ``host``
  #
  # @type [Rack::Request]
  attr_accessor :request

  # Denote url will be constructed as a path or an aboslute URL including
  # protocol, domain and port (when necessary).
  #
  # @type [Boolean]
  attr_accessor :path_only

  # Query-string parameters.
  #
  # @type [Hash]
  attr_accessor :query

  # @param [String] path
  def initialize(path)
    @path = path.gsub(%r{^/}, '')
    @path_only = self.path_only.nil? ? false : self.path_only
    @query = {}
    @request ||= nil
    @fragment ||= nil

    yield(self) if block_given?
  end

  def path_only?
    !!@path_only
  end

  # Get path.
  #
  # @return [String]
  def to_path
    path = [request.script_name, self.path].join('/')

    return path if query.empty?

    URI(path).tap do |uri|
      Hash[URI.decode_www_form(uri.query || '')].tap do |decoded_uri|
        query.each { |k, v| decoded_uri[k] = v }

        uri.query = URI.encode_www_form(decoded_uri)
      end

      return uri.to_s
    end
  end

  class << self
    protected

    # Get URL from given request.
    #
    # @return [String]
    def url_from(request, path_only: false)
      ports = [['http', 80], ['https', 443]]
      # @formatter:off
      [
        request.scheme, '://', request.host,
        { true => ":#{request.port}",
          false => nil }[!ports.include?([request.scheme, request.port])],
      ][(path_only ? -1 : 0)..-1].join('')
      # @formatter:on
    end
  end

  # Get URL.
  #
  # @return [String]
  def to_url
    self.class.__send__(:url_from, request, path_only: path_only?).tap do |url|
      return '%<url>s%<path>s%<fragment>s' % {
        url: url,
        path: self.to_path,
        fragment: (fragment ? "##{fragment}" : nil).to_s
      }
    end
  end

  # @return [URI::HTTP]
  def to_uri
    URI(to_url)
  end

  def freeze
    super.tap do
      [:fragment, :request, :path_only, :query].each do |attr|
        self.__send__(attr).freeze
      end
    end.freeze
  end

  alias_method 'uri', 'to_uri'

  alias_method 'to_s', 'to_url'
end
