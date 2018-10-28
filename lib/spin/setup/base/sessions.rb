# frozen_string_literal: true

enable(:sessions)
{
  key: 'unicorn',
  path: '/',
  expire_after: 2_592_000,
  secret: 'change_me',
  old_secret: 'also_change_me',
}.tap { |settings| set(:sessions, settings) }
