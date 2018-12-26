# frozen_string_literal: true

require_relative '../helpers'

# Provides useful methods related to assets
#
# ``asset_url`` provides cache busting URLs
#
# @see Sinatra::Base.public_dir
# @see https://github.com/sinatra/sinatra/blob/7a5c499f0e6099137fd1cb4ee20178af2a125d47/lib/sinatra/base.rb#L1378
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

  # @return [Time|nil]
  def asset_mtime
    'version.json'.tap do |version_file|
      Pathname.new(self.class.public_dir).join(version_file).tap do |file|
        return file.file? ? file.mtime : nil
      end
    end
  end

  # Get filepath (for public files).
  #
  # @return [Pathname]
  def asset_path(*args)
    args.map { |fp| fp.to_s.gsub(%r{^/*}, '') }.tap do |parts|
      return Pathname.new(self.class.public_dir).join(*parts)
    end
  end
end
