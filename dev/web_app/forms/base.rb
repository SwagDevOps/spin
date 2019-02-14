# frozen_string_literal: true

require_relative '../forms'
require 'dry/inflector'
require 'hanami/helpers'

# @abstract
class WebApp::Forms::Base
  include Hanami::Helpers

  attr_reader :params

  attr_reader :env

  attr_accessor :url

  attr_accessor :name

  attr_accessor :attributes

  class << self
    attr_reader :items

    protected

    attr_writer :items

    # Push new renderable.
    #
    # @param [Proc] callable
    def push(callable)
      self.items ||= []
      self.items.push(callable)

      self
    end
  end

  def initialize(env, params)
    self.env = env
    self.params = params

    Dry::Inflector.new.tap do |inf|
      inf.demodulize(self.class.name).tap do |class_name|
        self.name = inf.underscore(class_name)
      end
    end

    # self.url = '/sample'

    self.attributes = {
      class: 'mdl-card__supporting-text'
    }
  end

  class << self
    # Initialize a form using ``context``
    #
    # @param [Object] context
    # @return [self]
    def from(context = self)
      self.new(context.env, context.params)
    end
  end

  def call
    self.class.items.tap do |items|
      return build do
        items.each { |callable| instance_eval(&callable) }
      end
    end
  end

  def to_s
    call.to_s
  end

  def csrf_token
    Rack::Csrf.csrf_token(self.env)
  end

  protected

  def build(&block)
    prepare

    form_for(name, url, attributes, &block)
  end

  def prepare
    # called before build
  end

  attr_writer :params

  attr_writer :env
end
