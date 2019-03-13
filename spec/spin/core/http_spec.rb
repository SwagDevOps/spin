# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin::Core::Http, :'spin/core/http' do
  it { expect(described_class).to be_const_defined(:Url) }
end
