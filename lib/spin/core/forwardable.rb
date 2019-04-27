# frozen_string_literal: true

# # Introduction
#
# This library allows you delegate method calls to an object, on a method by
# method basis.
#
# Since Ruby 2.4, ``Forwardable`` will print a warning
# when calling a method that is private
# on a delegate, and in the future it could be an error:
# https://bugs.ruby-lang.org/issues/12782#note-3
# That's why we use a custom implementation
# to delegate private/protected methods.
#
#
# ## Notes
#
# Be advised, RDoc will not detect delegated methods.
#
# ``forwardable.rb`` provides single-method delegation via the
# ``def_delegator()`` and ``def_delegators()`` methods.
#
# ## Examples
#
# ### Forwardable
#
# Forwardable makes building a new class based on existing work, with a proper
# interface, almost trivial.  We want to rely on what has come before obviously,
# but with delegation we can take just the methods we need and even rename them
# as appropriate.  In many cases this is preferable to inheritance, which gives
# us the entire old interface, even if much of it isn't needed.
#
# ```ruby
# class Queue
#   extend Forwardable
#
#   def initialize
#     @q = [ ]    # prepare delegate object
#   end
#
#   # setup preferred interface, enq() and deq()...
#   def_delegator :@q, :push, :enq
#   def_delegator :@q, :shift, :deq
#
#   # support some general Array methods that fit Queues well
#   def_delegators :@q, :clear, :first, :push, :shift, :size
# end
#
# q = Queue.new
# q.enq 1, 2, 3, 4, 5
# q.push 6
#
# q.shift    # => 1
# while q.size > 0
#   puts q.deq
# end
#
# q.enq "Ruby", "Perl", "Python"
# puts q.first
# q.clear
# puts q.first
# ```
#
# Prints:
#
# ```
# 2
# 3
# 4
# 5
# 6
# Ruby
# nil
# ```
#
# Forwardable can be used to setup delegation at the object level as well.
#
# ```ruby
# printer = String.new
# printer.extend(Forwardable)              # prepare object for delegation
# printer.def_delegator("STDOUT", "puts")  # add delegation for STDOUT.puts()
# printer.puts "Howdy!"
# ```
#
# Also, Forwardable can be use to Class or Module.
#
# ```ruby
# module Facade
#    extend SingleForwardable
#    def_delegator :Implementation, :service
#
#    class Implementation
#       # def service...
#    end
#  end
# ```
#
# The Forwardable module provides delegation of specified
# methods to a designated object, using the methods #def_delegator
# and #def_delegators.
#
# For example, say you have a class RecordCollection which
# contains an array ``@records``.  You could provide the lookup method
# ``#record_number()``, which simply calls ``#[]`` on the ``@records`` array,
# like this:
#
# ```ruby
# class RecordCollection
#   extend Forwardable
#
#  def_delegator :@records, :[], :record_number
# end
# ```
#
# Further, if you wish to provide the methods #size, #<<, and #map,
# all of which delegate to @records, this is how you can do it:
#
# ```
# class RecordCollection
#   extend Forwardable
#
#   def_delegators :@records, :size, :<<, :map
# end
#
# f = Foo.new
# f.printf ...
# f.gets
# f.content_at(1)
# ```
#
# based on:
#
# ```code
#   forwardable.rb -
#       $Release Version: 1.1$
#       $Revision: 31685 $
#       by Keiju ISHITSUKA(keiju@ishitsuka.com)
# ```
#
# @see https://ruby-doc.org/stdlib-2.6/libdoc/forwardable/rdoc/Forwardable.html
# @see https://github.com/sj26/ruby-1.9.3-p0/blob/b6dccd90a6ed7750aebd7c4c7b37f2c95bc1538c/lib/forwardable.rb#L2
# @see https://bugs.ruby-lang.org/issues/12782
# @see https://github.com/pry/pry/blob/1d463198a9d3505584974c31812e0523144da30b/lib/pry/forwardable.rb#L7
module Spin::Core::Forwardable
  # Takes a hash as its argument.
  #
  # The key is a symbol or an array of symbols.
  # These symbols correspond to method names.
  # The value is the accessor to which the methods will be delegated.
  #
  # @param [Hash] hash
  def instance_delegate(hash)
    hash.each do |methods, accessor|
      (methods.respond_to?(:each) ? methods : [methods]).each do |method|
        def_instance_delegator(accessor, method)
      end
    end
  end

  # Shortcut for defining multiple delegator methods.
  #
  # Shortcut for defining multiple delegator methods,
  # but with no provision for using a different name.
  # The following two code samples have the same effect:
  #
  # ```ruby
  # def_delegators :@records, :size, :<<, :map
  # ```
  #
  # ```ruby
  # def_delegator :@records, :size
  # def_delegator :@records, :<<
  # def_delegator :@records, :map
  # ```
  def def_instance_delegators(accessor, *methods)
    # @formatter:off
    methods
      .reject { |m| %w[__send__ __id__].include?(m) }
      .each { |method| def_instance_delegator(accessor, method) }
    # @formatter:on
  end

  # Define ``method`` as delegator instance method.
  #
  # Define ``method`` as delegator instance method
  # with an optional alias name ``ali``.
  # Method calls to ``ali`` will be delegated to ``accessor.method``.
  #
  # ```ruby
  # class MyQueue
  #   extend Forwardable
  #   attr_reader :queue
  #
  #  def initialize
  #     @queue = []
  #  end
  #
  #   def_delegator :@queue, :push, :mypush
  # end
  #
  # q = MyQueue.new
  # q.mypush 42
  # q.queue    #=> [42]
  # q.push 23  #=> NoMethodError
  # ```
  def def_instance_delegator(accessor, method, ali = method)
    # @formatter:off
    __send__({
      true => :module_eval,
      false => :instance_eval
    }[self.respond_to?(:module_eval)], <<-"ACCESSORS", __FILE__, __LINE__ + 1)
      def #{ali}(*args, &block)
        begin
          #{accessor}.__send__(:#{method}, *args, &block)
        rescue Exception
          $@.delete_if{|s| %r"#{Regexp.quote(__FILE__)}"o =~ s}
          ::Kernel::raise
        end
      end
    ACCESSORS
    # @formatter:on
  end

  alias delegate instance_delegate
  alias def_delegators def_instance_delegators
  alias def_delegator def_instance_delegator
end
