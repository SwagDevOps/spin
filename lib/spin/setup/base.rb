# frozen_string_literal: true

set(:public_folder, "#{Dir.pwd}/public")
set(:views, Pathname.new(__FILE__).dirname.join('..', 'views').realpath.to_s)
