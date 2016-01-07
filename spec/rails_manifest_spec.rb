# encoding: UTF-8

require 'spec_helper'
require 'json'
require 'securerandom'
require 'yaml'

include GeneratedAssets

describe RailsManifest do
  shared_examples 'a compliant manifest' do
    describe '#find_by_logical' do
      it 'finds the digested asset for the logical one' do
        expect(manifest.find_by_logical('myfiles/file1.js')).to(
          eq('myfiles/file1-abc123.js')
        )

        expect(manifest.find_by_logical('myfiles/file2.css')).to(
          eq('myfiles/file2-def456.css')
        )
      end
    end
  end

  context 'with a json manifest (i.e. Rails 4)' do
    let(:manifest_hash) do
      {
        'files' => {
          'myfiles/file1-abc123.js' => {
            'logical_path' => 'myfiles/file1.js'
          },
          'myfiles/file2-def456.css' => {
            'logical_path' => 'myfiles/file2.css'
          }
        }
      }
    end

    let(:manifest_file) do
      app.root
        .join('public/assets')
        .join(".sprockets-manifest-#{SecureRandom.hex}.json")
    end

    before(:each) do
      FileUtils.mkdir_p(manifest_file.dirname)
      File.write(manifest_file, manifest_hash.to_json)
    end

    let(:manifest) { RailsManifest.load_for(app) }

    describe '.load_for' do
      it 'finds the json manifest and loads it' do
        expect(manifest).to be_a(JsonManifest)
      end
    end

    it_behaves_like 'a compliant manifest'
  end

  context 'with a yaml manifest (i.e. rails 3)' do
    let(:manifest_hash) do
      {
        'myfiles/file1.js' => 'myfiles/file1-abc123.js',
        'myfiles/file2.css' => 'myfiles/file2-def456.css'
      }
    end

    let(:manifest_file) do
      app.root.join('public/assets/manifest.yml')
    end

    before(:each) do
      FileUtils.mkdir_p(manifest_file.dirname)
      File.write(manifest_file, manifest_hash.to_json)
    end

    let(:manifest) { RailsManifest.load_for(app) }

    describe '.load_for' do
      it 'finds the yaml manifest and loads it' do
        expect(manifest).to be_a(YamlManifest)
      end
    end

    it_behaves_like 'a compliant manifest'
  end
end
