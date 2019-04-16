# frozen_string_literal: true

require_relative '../asset_url'

# Represent a list of possible (assets serving) hosts.
#
# Give a forge request, to replace original request used by ``AssetUrl``
class Spin::Core::Http::AssetUrl::Provider < Array
  autoload(:OpenStruct, 'ostruct')

  # @param [Array<String>] hosts
  def initialize(hosts)
    hosts.each do |host|
      self.push(URI.parse(host.to_s))
    end
  end

  # Get a struct imitating a ``Rack::Request``.
  #
  # @return [OpenStruct]
  def to_request
    OpenStruct.new.tap do |request|
      self.sample.tap do |host|
        request.host = host.hostname
        request.scheme = host.scheme
        request.port = host.port
      end
    end
  end
end
