# frozen_string_literal: true

set(:environment, (ENV['APP_ENV'] || :production).to_sym)
set(:public_folder, "#{Dir.pwd}/public")
set(:views, "#{Dir.pwd}/views")
