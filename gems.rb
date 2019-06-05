# frozen_string_literal: true

# bundle install --path vendor/bundle --clean

source 'https://rubygems.org'

group :default do
  gem 'bcrypt', '~> 3.1'
  gem 'concurrent-ruby', '~> 1.0'
  gem 'dry-auto_inject', '~> 0.6', '>= 0.6.0'
  gem 'dry-container', '~> 0.6'
  gem 'ice_nine', '~> 0.11'
  gem 'image_size', '~> 2.0'
  gem 'kamaze-version', '~> 1.0'
  gem 'moneta', '~> 1.0'
  gem 'tty-config', '~> 0.3'
end

group :fcgi do
  gem 'fcgi', '~> 0.9'
  gem 'rack', '~> 2.0.7'
end

group :web_app do
  # sinatra ------------------------------
  gem 'sinatra-contrib', '= 2.0.5'
  gem 'sinatra-flash', '~> 0.3'
  # optional support ---------------------
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8'
  gem 'dotenv', '~> 2.6'
  gem 'erubi', '~> 1.8'
  gem 'hanami-helpers', '~> 1.3'
  gem 'rack_csrf', '~> 2.6'
  gem 'warden', '~> 1.2'
  # database -----------------------------
  gem 'pg', '~> 1.1'
  gem 'rom', '~> 5.0'
end

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.61'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
  gem 'tty-table', '~> 0.10'
  gem 'tux', '~> 0.3'
  # repl ---------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
  gem 'pry-coolline', '~> 0.2'
  # doc ----------------------------------
  gem 'github-markup', '~> 3.0'
  gem 'redcarpet', '~> 3.4'
  gem 'yard', '~> 0.9'
  gem 'yard-coderay', '~> 0.1'
  # server -------------------------------
  gem 'puma', '~> 3.12'
  gem 'rerun', '~> 0.13'
end

group :test do
  gem 'faker', '~> 1.9'
  gem 'rspec', '~> 3.8'
  gem 'sham', '~> 2.0'
  gem 'simplecov', '~> 0.16'
end
