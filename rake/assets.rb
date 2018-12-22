# frozen_string_literal: true

require 'shellwords'
require 'fileutils'

webpack = 'node_modules/webpack/bin/webpack.js'
config  = 'node_modules/webpack-mix/setup/webpack.config.js'
command = [webpack, '--progress', '--hide-modules', '--config', config]

handler = lambda do |task, args, cmd = command|
  env = (args[:environment] || ENV['APP_ENV'] || 'production').to_s

  FileUtils.mkdir_p('public', verbose: true)
  sh({ 'NODE_ENV' => env }, Shellwords.join(cmd), verbose: false)
  task.reenable
end

desc 'Build assets'
task :assets, [:environment] do |task, args|
  handler.call(task, args)
end

desc 'Watch assets'
task 'assets:watch', [:environment] do |task, args|
  command.clone.push('--watch').tap do |cmd|
    handler.call(task, args, cmd)
  end
end
