# frozen_string_literal: true

# class methods -----------------------------------------------------
describe Spin::Base, :'spin/base' do
  let(:described_class) { sham!(:'spin/base').class_builder.call }
  let(:confg) { sham!(:'spin/base').container.fetch(:config) }
  let(:container) { sham!(:'spin/base').container }
  let(:tested_class) do
    sham!(:'spin/base').class_builder.call.tap do |klass|
      klass.__send__('container=', container)

      return klass
    end
  end

  context '.container=' do
    it { expect(tested_class.__send__('container=', container)).to be_a(Hash) }
  end

  # @formatter:off
  {
    answer: Integer,
    config: OpenStruct,
  }.each do |k, v|
    context ".container[:#{k}]" do
      it { expect(tested_class.__send__(:container)[k]).to be_a(v) }
    end
  end
  # @formatter:on
end

describe Spin::Base, :'spin/base' do
  let(:described_class) { sham!(:'spin/base').class_builder.call }
  let(:confg) { sham!(:'spin/base').container.fetch(:config) }
  let(:container) { sham!(:'spin/base').container }
  let(:tested_class) do
    sham!(:'spin/base').class_builder.call.tap do |klass|
      klass.__send__('container=', container)

      return klass
    end
  end

  context '.config' do
    it { expect(described_class.__send__(:config)).to be(nil) }
    it { expect(tested_class.__send__(:config)).to be_a(OpenStruct) }
  end

  # @formatter:off
  {
    path: String,
    ratio: Float,
    primes: Array,
  }.each do |k, v|
    context ".config[:#{k}]" do
      it { expect(tested_class.__send__(:config)[k]).to be_a(v) }
    end
  end
  # @formatter:on
end
