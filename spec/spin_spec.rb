# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin, :spin do
  it { expect(described_class).to be_const_defined(:VERSION) }
  it { expect(described_class).to be_const_defined(:Autoloadable) }
  it { expect(described_class).to be_const_defined(:Base) }
  it { expect(described_class).to be_const_defined(:Core) }
  it { expect(described_class).to be_const_defined(:Controller) }
  it { expect(described_class).to be_const_defined(:DI) }
  it { expect(described_class).to be_const_defined(:Helpers) }
  it { expect(described_class).to be_const_defined(:User) }
end

# class methods -----------------------------------------------------
describe Spin, :spin do
  context '.constants' do
    it { expect(described_class.constants).to include(:DI) }
  end
end

# @see https://www.rubydoc.info/github/dry-rb/dry-auto_inject/master/Dry/AutoInject/Builder
describe Spin, :spin, :'spin/di' do
  context '::DI' do
    let(:subject) do
      silence_stream($stdout) do
        described_class.const_get(:DI)
      end
    end

    it { expect(subject).to respond_to(:container) }
    it { expect(subject).to respond_to(:strategies) }
    it { expect(subject).to respond_to(:'[]') }
  end
end

# instance methods --------------------------------------------------
describe Spin, :spin do
  let(:subject) do
    silence_stream($stdout) { described_class.new }
  end

  it { expect(subject).to respond_to(:container) }
end

# const_missing -----------------------------------------------------
describe Spin, :spin do
  context '.const_get' do
    it do
      # @formatter:off
      expect { described_class.const_get(:InexistingConstant) }
        .to raise_error(NameError)
      # @formatter:on
    end
  end
end

# testing inheritance
#
# ``Base`` SHOULD be inherited as a class constant,
# specific to each class, avoiding to pollute each other.
# -------------------------------------------------------------------
describe Spin::Base, :spin, :'spin/base' do
  let(:parent_class) { Spin::Base }
  let(:described_class) { sham!(:spin).class_builder.call::Base }

  it { expect(described_class).not_to eq(parent_class) }

  context '.ancestors' do
    it { expect(described_class.ancestors).to include(parent_class) }
  end
end

describe Spin, :spin do
  let(:described_class) { sham!(:spin).class_builder.call }

  # ``build`` is a method, but protected or private (not public)
  :build.tap do |method|
    it { expect(described_class).not_to respond_to(method) }
    context '.methods' do
      it { expect(described_class.methods).to include(method) }
    end
  end
end

describe Spin, :spin do
  let(:described_class) { sham!(:spin).class_builder.call }
  let(:container_builder) { described_class.__send__(:container_builder) }

  context '.container_builder' do
    it { expect(container_builder).to be_a(Proc) }
  end

  # @formatter:off
  {
    entry_class: Class,
    base_class: Class,
    config: Spin::Core::Config,
    controller_class: Class,
    paths: Array,
    storage_path: Pathname,
  }.each do |key, type| # @formatter:on
    context ".container_builder.call[#{key}.inspect]" do
      it do
        # @type [Proc] container_builder
        container_builder.call[key].tap { |item| expect(item).to be_a(type) }
      end
    end
  end
end

describe Spin, :spin do
  let(:described_class) { sham!(:spin).class_builder.call }

  # same inherited class should be initializable several times
  context '.new' do
    it do
      10.times { described_class.new }
    end
  end
end
