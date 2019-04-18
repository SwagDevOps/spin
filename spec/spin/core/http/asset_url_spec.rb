# frozen_string_literal: true

require 'ostruct'
require 'uri'

# constants ---------------------------------------------------------
describe Spin::Core::Http::AssetUrl, :'spin/core/http/asset_url' do
  it { expect(described_class).to be_const_defined(:Provider) }
end

# instance methods --------------------------------------------------
describe Spin::Core::Http::AssetUrl, :'spin/core/http/asset_url' do
  let(:request) do
    OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
  end
  let(:subject) do
    Spin::Core::Http::AssetUrl.new('sample/1') do |url|
      url.request = request
    end
  end

  # attributes ------------------------------------------------------
  it { expect(subject).to respond_to(:path) }
  it { expect(subject).to respond_to(:fragment) }
  it { expect(subject).to respond_to(:fragment=) }
  it { expect(subject).to respond_to(:request) }
  it { expect(subject).to respond_to(:request=) }
  it { expect(subject).to respond_to(:request?) }
  it { expect(subject).to respond_to(:path_only) }
  it { expect(subject).to respond_to(:path_only=) }
  it { expect(subject).to respond_to(:query) }
  it { expect(subject).to respond_to(:query=) }
  # methods ---------------------------------------------------------
  it { expect(subject).to respond_to(:path_only?) }
  it { expect(subject).to respond_to(:to_path) }
  it { expect(subject).to respond_to(:to_url) }
  it { expect(subject).to respond_to(:to_uri) }
  it { expect(subject).to respond_to(:uri) }
end

# request -----------------------------------------------------------
describe Spin::Core::Http::AssetUrl, :'spin/core/http/asset_url' do
  let(:config) do
    { 'assets.hosts' => ['http://example.org/'] }
  end
  let(:subject) do
    Spin::Core::Http::AssetUrl.new('sample/1', config: config)
  end

  context '#request?' do
    it { expect(subject.request?).to eq(true) }
  end

  context '#request' do
    it { expect(subject.request).to be_a(OpenStruct) }
  end
end

# to_uri scheme + host ----------------------------------------------
describe Spin::Core::Http::AssetUrl, :'spin/core/http/asset_url' do
  let(:config) do
    { 'assets.hosts' => ['http://example.org/'] }
  end
  let(:subject) do
    Spin::Core::Http::AssetUrl.new('sample/1', config: config)
  end

  context '#to_uri.host' do
    it { expect(subject.to_uri.host).to eq('example.org') }
  end

  context '#to_uri.scheme' do
    it { expect(subject.to_uri.scheme).to eq('http') }
  end
end
