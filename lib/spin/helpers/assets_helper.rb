# frozen_string_literal: true

require_relative '../helpers'

# Provides useful methods related to assets
#
# ``asset_url`` provides cache busting URLs
module Spin::Helpers::AssetsHelper
  autoload(:Pathname, 'pathname')
  autoload(:URI, 'uri')
  autoload(:ImageSize, 'image_size')

  include Spin::Helpers::UrlHelper

  # @see Hanami::Helpers::LinkToHelper.link_to()
  def asset_url(path, path_only: false)
    URI(url_for(path, path_only: path_only)).tap do |uri|
      if asset_mtime
        Hash[URI.decode_www_form(uri.query || '')].tap do |decoded_uri|
          decoded_uri["t#{asset_mtime.to_f}"] = nil

          uri.query = URI.encode_www_form(decoded_uri)
        end
      end

      return uri.to_s
    end
  end

  # @return [ImageSize|nil]
  def image_size(path)
    asset_path(path).tap do |fp|
      return nil unless fp.file?

      File.open(fp, 'rb') { |fh| return ImageSize.new(fh) }
    end
  end

  # @return [Time]
  def asset_mtime
    Pathname.new('public/version.json').tap do |version_file|
      return version_file.file? ? version_file.mtime : nil
    end
  end

  # Get filepath (for public files).
  #
  # @return [Pathname]
  def asset_path(*args)
    (['public'] + args).map { |fp| fp.to_s.gsub(%r{^/*}, '') }.tap do |parts|
      return Pathname.new(Dir.pwd).join(*parts)
    end
  end
end
