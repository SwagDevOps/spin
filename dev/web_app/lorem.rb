#!/usr/bin/env ruby
# frozen_string_literal: true

# Sample of use:
#
# ```sh
# lorem
# lorem -n 28
# ```
require_relative '../web_app'

# User class
class WebApp::Lorem
  # rubocop:disable Lint/PercentStringArray
  WORDS = [
    # The standard Lorem Ipsum passage, used since the 1500s
    %w[Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do],
    %w[eiusmod tempor incididunt ut labore et dolore magna aliqua.],
    %w[Ut enim ad minim veniam quis nostrud exercitation ullamco laboris],
    %w[nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in],
    %w[reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla],
    %w[pariatur. Excepteur sint occaecat cupidatat non proident],
    %w[sunt in culpa qui officia deserunt mollit anim id est laborum],
    # Section 1.10.32 of "de Finibus Bonorum et Malorum",
    # written by Cicero in 45 BC
    %w[Sed ut perspiciatis unde omnis iste natus error sit voluptatem],
    %w[accusantium doloremque laudantium totam rem aperiam eaque ipsa quae],
    %w[ab illo inventore veritatis et quasi architecto beatae vitae dicta],
    %w[sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit],
    %w[aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos],
    %w[qui ratione voluptatem sequi nesciunt. Neque porro quisquam est],
    %w[qui dolorem ipsum quia dolor sit amet consectetur adipisci velit],
    %w[sed quia non numquam eius modi tempora incidunt ut labore et dolore],
    %w[magnam aliquam quaerat voluptatem. Ut enim ad minima veniam quis],
    %w[nostrum exercitationem ullam corporis suscipit laboriosam nisi ut],
    %w[aliquid ex ea commodi consequatur? Quis autem vel eum iure],
    %w[reprehenderit qui in ea voluptate velit esse quam nihil molestiae],
    %w[consequatur vel illum qui dolorem eum fugiat quo voluptas nulla],
    %w[pariatur?],
  ].flatten
  # rubocop:enable Lint/PercentStringArray

  def initialize(**options)
    @options = { count: 124 }.merge(options)
  end

  def call
    coeff = (options.fetch(:count) / words.size).to_i + 1

    (self.words * coeff)
      .first(options.fetch(:count))
      .tap { |words| return words.join(' ') }
  end

  alias to_s call

  protected

  attr_accessor :options

  def words
    self.class.const_get(:WORDS)
  end
end
