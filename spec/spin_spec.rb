# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin, :spin do
  it { expect(described_class).to be_const_defined(:VERSION) }
  it { expect(described_class).to be_const_defined(:Autoloadable) }
  it { expect(described_class).to be_const_defined(:Base) }
  it { expect(described_class).to be_const_defined(:Config) }
  it { expect(described_class).to be_const_defined(:Container) }
  it { expect(described_class).to be_const_defined(:Controller) }
  it { expect(described_class).to be_const_defined(:DI) }
  it { expect(described_class).to be_const_defined(:Helpers) }
  it { expect(described_class).to be_const_defined(:Initializer) }
  it { expect(described_class).to be_const_defined(:Setup) }
  it { expect(described_class).to be_const_defined(:User) }
end

# class methods -----------------------------------------------------
describe Spin, :spin do
  context '.constants' do
    let(:expected) do
      # @formatter:off
      [:Container,
       :Pathname,
       :Controller,
       :Helpers,
       :Initializer,
       :Setup,
       :User,
       :VERSION,
       :Dotenv,
       :Autoloadable,
       :Base,
       :Config,
       :DI].sort
      # @formatter:on
    end

    it { expect(described_class.constants.sort).to eq(expected) }
  end
end

# @see https://www.rubydoc.info/github/dry-rb/dry-auto_inject/master/Dry/AutoInject/Builder
describe Class, :'spin/di' do
  let(:subject) { Spin.const_get(:DI) }

  it { expect(subject).to respond_to(:container) }
  it { expect(subject).to respond_to(:strategies) }
  it { expect(subject).to respond_to(:'[]') }
end

# instance methods --------------------------------------------------
describe Spin, :spin do
  let(:subject) do
    silence_stream($stdout) { described_class.new }
  end

  it { expect(subject).to respond_to(:container) }

  # missing methods
  it { expect(subject).to respond_to(:paths) }
  it { expect(subject).to respond_to(:controller_class) }
end
