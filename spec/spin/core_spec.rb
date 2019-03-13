# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin::Core, :'spin/core' do
  it { expect(described_class).to be_const_defined(:Autoloadable) }
  it { expect(described_class).to be_const_defined(:Cache) }
  it { expect(described_class).to be_const_defined(:Config) }
  it { expect(described_class).to be_const_defined(:Container) }
  it { expect(described_class).to be_const_defined(:Html) }
  it { expect(described_class).to be_const_defined(:Http) }
  it { expect(described_class).to be_const_defined(:Initializer) }
  it { expect(described_class).to be_const_defined(:Injectable) }
  it { expect(described_class).to be_const_defined(:Setup) }
end
