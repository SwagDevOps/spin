# frozen_string_literal: true

require_relative './url'

# Represent an asset URL.
class Spin::Core::Http::AssetUrl < Spin::Core::Http::Url
  include Spin::Core::Injectable

  inject(:config)

  autoload(:Provider, "#{__dir__}/asset_url/provider")

  def initialize(fragment, **options)
    hosts_from_config(options[:config]).tap do |hosts|
      self.provider ||= Provider.new(hosts) if hosts and !hosts.empty?
    end

    super(fragment)
  end

  # Denote request is already set.
  #
  # @return [Boolean]
  def request?
    !self.request.nil?
  end

  # @return [OpenStruct|Rack::Request]
  def request
    self.provider&.to_request || super
  end

  protected

  attr_accessor(:provider)

  # @param [Spin::Core::Config] config
  #
  # @retuurn [Array<string>|nil]
  def hosts_from_config(config)
    Array.new(config&.public_send('[]', 'assets.hosts') || []).delete_if do |v|
      v.to_s.empty?
    end.freeze
  rescue TTY::Config::ReadError
    nil
  end
end
