# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Spin::ConfigReader, :'spin/config_reader' do
  it { expect(described_class).to be_const_defined(:Cache) }
  it { expect(described_class).to be_const_defined(:Loader) }
end

describe Spin::ConfigReader, :'spin/config_reader' do
  let(:paths) { [SAMPLES_PATH.join('config')] }
  let(:subject) { described_class.new(paths) }

  it { expect(subject).to respond_to(:get) }

  context '.get' do
    it { expect(subject.get('app')).to be_frozen }
    it { expect(subject.get('app')).to be_a(OpenStruct) }

    it { expect(subject.get('app.math')).to be_frozen }
    it { expect(subject.get('app.math')).to be_a(OpenStruct) }
    it { expect(subject.get('app.math.PI')).to eq(3.14159) }

    it { expect(subject.get('app.heroes')).to be_frozen }
    it { expect(subject.get('app.heroes')).to be_a(Array) }
  end
end

# paths should include ``APP_ENV`` ----------------------------------
describe Spin::ConfigReader, :'spin/config_reader' do
  let(:paths) { [SAMPLES_PATH.join('config')] }
  let(:subject) { described_class.new(paths) }

  context '.to_a' do
    let(:app_env) { 'test' }
    let(:expected_paths) do
      # @formatter:off
      [
        SAMPLES_PATH.join('config', app_env),
        SAMPLES_PATH.join('config')
      ]
      # @formatter:on
    end

    it do
      with_env('APP_ENV' => app_env) do
        expect(subject.to_a).to eq(expected_paths)
      end
    end
  end
end

# all values should be frozen ---------------------------------------
describe Spin::ConfigReader, :'spin/config_reader' do
  let(:paths) { [SAMPLES_PATH.join('config')] }
  let(:subject) { described_class.new(paths) }

  let(:tested) { subject.get('app.heroes').map(&:frozen?).uniq }

  context '.get().map(&:frozen?).uniq' do
    it { expect(tested).to eq([true]) }
  end
end

# merging files by env ----------------------------------------------
describe Spin::ConfigReader, :'spin/config_reader', :wip do
  let(:paths) { [SAMPLES_PATH.join('config')] }
  let(:app_env) { 'test' }
  let(:subject) do
    with_env('APP_ENV' => app_env) do
      described_class.new(paths)
    end
  end

  it { expect(subject).to respond_to(:get) }

  context '.get' do
    it { expect(subject.get('app.version')).to be_a(OpenStruct) }
    it { expect(subject.get('app.math')).to be_a(OpenStruct) }
  end
end
