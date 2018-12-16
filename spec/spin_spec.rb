# frozen_string_literal: true

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
