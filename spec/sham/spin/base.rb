# frozen_string_literal: true

autoload(:SecureRandom, 'securerandom')
autoload(:OpenStruct, 'ostruct')

# Sample of use:
#
# ```
# describe Spin::Base, :'spin/base' do
#   let(:confg) { sham!(:'spin/base').container.fetch(:config) }
#   let(:container) { sham!(:'spin/base').container }
#   let(:tested_class) do
#     sham!(:'spin/base').class_builder.call.tap do |klass|
#       klass.__send__('container=', container)
#
#       return klass
#     end
#   end
# ```
Sham.config(FactoryStruct, :'spin/base') do |c|
  c.attributes do
    # @formatter:off
    {
      container: {
        answer: 42,
        config:
            OpenStruct.new(
              path: __dir__,
              ratio: 0.75,
              primes: [
                2, 3, 5, 7, 11, 13, 17, 19,
                23, 29, 31, 37, 41, 43, 47,
                53, 59, 61, 67, 71, 73, 79, 83, 89, 97
              ]
            )
      },
      class_builder: lambda do
        ['Test', SecureRandom.hex, 'Class'].join('').tap do |class_name|
          Object.const_set(class_name, Class.new(Spin::Base))

          return Object.const_get(class_name)
        end
      end
    }
    # @formatter:on
  end
end
