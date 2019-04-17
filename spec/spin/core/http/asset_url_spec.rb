# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin::Core::Http::AssetUrl, :'spin/core/http/asset_url' do
  it { expect(described_class).to be_const_defined(:Provider) }
end
