# frozen_string_literal: true

require_relative '../helpers'

# Provides useful methods related to assets
#
# ``asset_url`` provides cache busting URLs
module Spin::Helpers::AssetsHelper
  autoload(:Pathname, 'pathname')
  autoload(:URI, 'uri')

  include Spin::Helpers::UrlHelper

  # @see Hanami::Helpers::LinkToHelper.link_to()
  def asset_url(path)
    URI(url_for(path)).tap do |uri|
      if asset_mtime
        Hash[URI.decode_www_form(uri.query || '')].tap do |decoded_uri|
          decoded_uri["t#{asset_mtime.to_f}"] = nil

          uri.query = URI.encode_www_form(decoded_uri)
        end
      end

      return uri.to_s
    end
  end

  # @return [Time]
  def asset_mtime
    Pathname.new('public/version.json').tap do |version_file|
      return version_file.file? ? version_file.mtime : nil
    end
  end
end
