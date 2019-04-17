# frozen_string_literal: true

require_relative './url'

# Represent an asset URL.
class Spin::Core::Http::AssetUrl < Spin::Core::Http::Url
  include Spin::Core::Injectable

  inject(:config)

  autoload(:Provider, "#{__dir__}/asset_url/provider")

  def initialize(fragment, **options)
    options[:config]&.public_send('[]', 'assets.hosts').tap do |hosts|
      if hosts and self.provider.nil?
        self.provider = Provider.new(hosts)
      end
    end

    super(fragment)
  end

  # Denote request is already set.
  #
  # @return [Boolean]
  def request?
    !self.request.nil?
  end

  def request
    self.provider.to_request || super
  end

  protected

  attr_accessor(:provider)
end
