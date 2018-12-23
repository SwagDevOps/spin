# frozen_string_literal: true

require 'shellwords'

command = ['npx', 'sort-package-json']

handler = lambda do |task, args, cmd = command|
  env = (args[:environment] || ENV['APP_ENV'] || 'production').to_s

  sh({ 'NODE_ENV' => env }, Shellwords.join(cmd), verbose: false)
  task.reenable
end

desc 'Sort package.json'
task :'package:sort', [:environment] do |task, args|
  handler.call(task, args)
end
