# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin::ConfigReader, :'spin/config_reader' do
  it { expect(described_class).to be_const_defined(:Cache) }
  it { expect(described_class).to be_const_defined(:Loader) }
end
