# frozen_string_literal: true

require 'shellwords'

handler = lambda do |task, command, args = {}|
  env = (args[:environment] || ENV['APP_ENV'] || 'production').to_s

  sh({ 'NODE_ENV' => env }, Shellwords.join(command), verbose: false)
  task.reenable
end

desc 'Package'
task :package do
  [:'package:sort', :'package:install'].each do |t|
    Rake::Task[t].invoke
  end
end

desc 'Sort package.json'
task :'package:sort' do |task|
  ['npx', 'sort-package-json'].tap do |command|
    handler.call(task, command)
  end
end

desc 'Install package(s)'
task :'package:install' do |task|
  ['npm', 'install'].tap do |command|
    handler.call(task, command)
  end
end
