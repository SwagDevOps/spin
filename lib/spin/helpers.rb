# frozen_string_literal: true

require_relative '../spin'

# Namespace for helpers
module Spin::Helpers
  {
    AssetsHelper: :assets_helper,
    ErbCacheHelper: :erb_cache_helper,
    PageTitleHelper: :page_title_helper,
    UrlHelper: :url_helper,
  }.each { |k, v| autoload(k, "#{__dir__}/helpers/#{v}") }

  def self.included(base)
    base.class_eval do
      include UrlHelper
      include AssetsHelper
      include PageTitleHelper
      include ErbCacheHelper
    end
  end
end
