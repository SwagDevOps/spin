# frozen_string_literal: true

require_relative '../spin'

# Base mount
#
# @abstract Subclass is expected to implement #call
class Spin::Mount
  {
    Config: :config,
    Logger: :logger,
  }.each { |k, v| autoload k, "#{__dir__}/mount/#{v}" }

  def initialize(base_class, config)
    @base_class = base_class
    @config = config
  end

  # Get settings
  #
  # @return [Hash{Symbol => Object}]
  def settings
    Hash[config.to_h.fetch('settings', {}).map { |(k, v)| [k.to_sym, v] }]
  end

  # @!method call
  #    Mount something, based on config.

  protected

  attr_reader :base_class

  attr_reader :config
end
