# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

# rubocop:disable Style/ParallelAssignment
begin
  # @see https://github.com/sinatra/sinatra/issues/1476
  # @see https://github.com/sinatra/sinatra/pull/1477
  original_stdout, original_stderr = $stdout.clone, $stderr.clone
  $stdout.reopen File.new('/dev/null', 'w')
  $stdout.reopen File.new('/dev/null', 'w')

  require_relative 'lib/spin'
ensure
  $stdout.reopen original_stdout
  $stderr.reopen original_stderr
end
# rubocop:enable Style/ParallelAssignment

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'rake'
end

if Gem::Specification.find_all_by_name('kamaze-project').any?
  require 'kamaze/project'

  self.tap do |main|
    Kamaze.project do |project|
      project.subject = Spin
      project.name    = 'spin'
      project.tasks   = [
        'cs:correct', 'cs:control', 'cs:pre-commit',
        'gem',
        'misc:gitignore',
        'shell',
        'test',
        'version:edit',
      ]
    end.load!
  end

  task default: [:gem]
end
