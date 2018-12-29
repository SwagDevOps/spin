# frozen_string_literal: true

set(:root, Dir.pwd)
set(:environment, (ENV['APP_ENV'] || :production).to_sym)
set(:public_folder, "#{root}/public")
set(:views, "#{root}/views")
