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
describe Class.new(Spin)::Base, :spin, :'spin/base' do
  it { expect(described_class).not_to eq(Spin::Base) }

  context '.ancestors' do
    it { expect(described_class.ancestors).to include(Spin::Base) }
  end
end
