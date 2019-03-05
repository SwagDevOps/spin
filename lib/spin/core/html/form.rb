# frozen_string_literal: true

require_relative '../html'
require 'dry/inflector'
require 'hanami/helpers'

# @abstract
class Spin::Core::Html::Form
  autoload(:Pathname, 'pathname')
  include Hanami::Helpers
  include(Spin::Core::Injectable)
  inject(:paths, strategy: :kwargs)

  # @type [Hash]
  attr_reader :params

  # @type [Hash]
  attr_reader :env

  # @type [String]
  attr_accessor :url

  # @type [String]
  attr_accessor :name

  # @type [Hash]
  attr_accessor :attributes

  # @return [Array<Proc>]
  attr_reader :structure

  class << self
    protected

    # @return [Array]
    def structure
      @structure ||= []
    end

    def push(*args)
      self.structure.push(*args)
    end
  end

  # @param [Object] context
  def initialize(context, **options)
    with_context(context) do |form|
      form.structure = self.class.__send__(:structure).clone.freeze
      form.paths = options.fetch(:paths, []).clone.freeze

      form.name = default_name
      form.attributes = {}
    end
  end

  # Build a form.
  #
  # @return [Hanami::Helpers::FormHelper::FormBuilder]
  def call
    self.structure.tap do |items|
      return build do
        items.each { |callable| instance_eval(&callable) }
      end
    end
  end

  def to_s
    call.to_s
  end

  # @return [String|nil]
  def csrf_token
    Rack::Csrf.csrf_token(self.env)
  rescue NameError
    nil
  end

  # Use a boilerplate file to redefine behavior.
  #
  # @todo Define a loader, to load files from injected paths or given filepath.
  #
  # @param [String] filepath
  # @return [self]
  def overload(filepath)
    self.tap do |form|
      form.structure = lambda do |structure, fp|
        Pathname.new(fp).realpath.read.tap do |content|
          # @formatter:off
          return Array.new(structure)
                      .instance_eval(content, Pathname.new(fp).realpath.to_s, 1)
                      .freeze
          # @formatter:on
        end
      end.call(form.structure, filepath)
    end
  end

  protected

  # @type [Array<String>]
  attr_writer :paths

  # @type [Array<Proc>]
  attr_writer :structure

  # @type [Hash]
  attr_writer :params

  # @type [Hash]
  attr_writer :env

  def build(&block)
    form_for(name, url, attributes, &block)
  end

  # @param [Object] context
  #
  # @return [self]
  def with_context(context)
    context.tap do |c|
      self.env = c.env
      self.params = c.params
    end

    self.tap { yield(self) if block_given? }
  end

  # Get default name.
  #
  # @return [String]
  def default_name
    Dry::Inflector.new.tap do |inf|
      inf.demodulize(self.class.name).tap do |class_name|
        return inf.underscore(class_name)
      end
    end
  end
end
