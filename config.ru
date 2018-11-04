# frozen_string_literal: true

require_relative 'lib/spin'

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'rack'
end

run(Spin.controller)
