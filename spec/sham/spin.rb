# frozen_string_literal: true

require 'securerandom'

Sham.config(FactoryStruct, :spin) do |c|
  c.attributes do
    {
      # @formatter:off
      class_builder: lambda do
        ['Test', SecureRandom.hex, 'Class'].join('').tap do |class_name|
          Object.const_set(class_name, Class.new(Spin))

          return Object.const_get(class_name)
        end
      end
      # @formatter:on
    }
  end
end
