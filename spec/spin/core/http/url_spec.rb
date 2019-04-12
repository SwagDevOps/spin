# frozen_string_literal: true

require 'ostruct'
require 'uri'

# instance methods --------------------------------------------------
describe Spin::Core::Http::Url, :'spin/core/http/url' do
  let(:subject) do
    request = OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
    Spin::Core::Http::Url.new('sample/1') do |url|
      url.request = request
    end
  end

  # attributes ------------------------------------------------------
  it { expect(subject).to respond_to(:path) }
  it { expect(subject).to respond_to(:fragment) }
  it { expect(subject).to respond_to(:fragment=) }
  it { expect(subject).to respond_to(:request) }
  it { expect(subject).to respond_to(:request=) }
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

# output ------------------------------------------------------------
describe Spin::Core::Http::Url, :'spin/core/http/url' do
  let(:subject) do
    request = OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
    Spin::Core::Http::Url.new('sample/1') do |url|
      url.request = request
    end
  end

  context '.to_path' do
    it { expect(subject.to_path).to eq('/sample/1') }
  end

  context '.to_url' do
    it { expect(subject.to_url).to match(%r{^http://}) }
    it { expect(subject.to_url).to be_a(String) }
    it { expect(subject.to_url).to eq('http://example.org/sample/1') }
  end

  context '.to_uri' do
    it { expect(subject.to_uri).to be_a(URI) }
  end

  context '.path_only?' do
    it { expect(subject.path_only).to be(false) }
  end
end

describe Spin::Core::Http::Url, :'spin/core/http/url' do
  let(:subject) do
    request = OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
    Spin::Core::Http::Url.new('sample/2') do |url|
      url.request = request
      url.query = { q: 'verb', t: '10000' }
    end
  end

  context '.to_path' do
    it { expect(subject.to_path).to eq('/sample/2?q=verb&t=10000') }
  end

  context '.query' do
    it { expect(subject.query).to eq(q: 'verb', t: '10000') }
  end

  'http://example.org/sample/2?q=verb&t=10000'.tap do |url|
    context '.to_url' do
      it { expect(subject.to_url).to eq(url) }
    end
  end
end

describe Spin::Core::Http::Url, :'spin/core/http/url' do
  let(:subject) do
    request = OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
    Spin::Core::Http::Url.new('sample/2') do |url|
      url.request = request
      url.fragment = 'anchor'
      url.query = { q: 'verb', t: '10000' }
    end
  end

  context '.to_path' do
    it { expect(subject.to_path).to eq('/sample/2?q=verb&t=10000') }
  end

  context '.query' do
    it { expect(subject.query).to eq(q: 'verb', t: '10000') }
  end

  'http://example.org/sample/2?q=verb&t=10000#anchor'.tap do |url|
    context '.to_url' do
      it { expect(subject.to_url).to eq(url) }
    end

    context '.to_uri' do
      it { expect(subject.to_uri).to eq(URI(url)) }
    end
  end
end

# freeze examples ---------------------------------------------------
describe Spin::Core::Http::Url, :'spin/core/http/url' do
  let(:subject) do
    request = OpenStruct.new(host: 'example.org', scheme: 'http', port: 80)
    Spin::Core::Http::Url.new('sample/1') do |url|
      url.request = request
    end.freeze
  end

  it { expect(subject).to be_frozen }

  [:fragment, :request, :path_only, :query].each do |method|
    context ".#{method}" do
      it { expect(subject.__send__(method)).to be_frozen }
    end
  end
end
