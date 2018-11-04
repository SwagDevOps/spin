# frozen_string_literal: true

set(:environment, (ENV['APP_ENV'] || :production).to_sym)
set(:public_folder, "#{Dir.pwd}/public")
set(:views, Pathname.new(__FILE__).dirname.join('..', 'views').realpath.to_s)
