# frozen_string_literal: true

# bundle install --path vendor/bundle --clean

source 'https://rubygems.org'

group :default do
  gem 'bcrypt', '~> 3.1'
  gem 'dry-auto_inject', '~> 0.6', '>= 0.6.0'
  gem 'dry-container', '~> 0.6'
  gem 'kamaze-version', '~> 1.0'
  gem 'sqlite3', '~> 1.3'
  gem 'tty-config', '~> 0.3'
end

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.60'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
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
  gem 'shotgun', '~> 0.9'
  # optional support ---------------------
  gem 'dotenv', '~> 2.5'
  gem 'erubi', '~> 1.7'
  gem 'hanami-helpers', '~> 1.3'
  gem 'rack_csrf', '~> 2.6'
  gem 'sinatra-contrib', '= 2.0.2'
  gem 'sinatra-flash', '~> 0.3'
  gem 'sinatra-logger', '~> 0.2'
  gem 'warden'
end

group :test do
  gem 'faker', '~> 1.9'
  gem 'rspec', '~> 3.8'
  gem 'sham', '~> 2.0'
end
