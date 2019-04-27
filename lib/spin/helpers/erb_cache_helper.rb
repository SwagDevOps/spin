# frozen_string_literal: true

require_relative '../helpers'

# Provides simple caching.
#
# ```
# <% erb_cache(:fragment, expires: 60) do %>
#   ... Cached stuff ...
# <% end %>
# ```
module Spin::Helpers::ErbCacheHelper
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # @return [Boolean]
  def erb_cache(name, options = {})
    false.tap do |stored|
      erb_cache_instance(options).tap do |cache|
        cache.cache(name) do
          stored = true
          pos = @_out_buf.length

          yield[pos..-1]
        end.tap { |result| @_out_buf << result unless stored }
      end.close
    end
  end

  protected

  # @return [Spin::Cache]
  def erb_cache_instance(options = {})
    Spin::Core::Cache.new(:File, options.merge(dir: erb_cache_path))
  end

  # @return [Pathname]
  def erb_cache_path
    Pathname.new(Dir.pwd).join('storage/cache/erb')
  end
end
