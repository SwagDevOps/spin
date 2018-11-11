# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

require_relative 'lib/spin'

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

require_relative 'rake/assets'
