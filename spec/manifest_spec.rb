# encoding: UTF-8

require 'spec_helper'

include GeneratedAssets

describe Manifest do
  let(:manifest) do
    Manifest.new(app, tmpdir)
  end

  let(:assets_config) do
    app.config.assets
  end

  let(:logical_path) do
    'foo/bar.txt'
  end

  describe '#add' do
    it 'adds a new entry to the manifest' do
      expect { manifest.add(logical_path) }.to(
        change { manifest.entries.size }.by(1)
      )
    end
  end

  describe '#apply!' do
    it 'writes all files' do
      manifest.add('foo/bar.txt') { "Bar's text" }
      manifest.add('foo/baz.txt') { "Baz's text" }
      manifest.apply!

      expect(tmpdir.join('foo/bar.txt').read).to eq("Bar's text")
      expect(tmpdir.join('foo/baz.txt').read).to eq("Baz's text")
    end

    it "writes all files and adds those marked to the app's precompile list" do
      manifest.add('foo/bar.txt') { "Bar's text" }
      manifest.add('foo/baz.txt', precompile: true) { "Baz's text" }
      manifest.apply!

      expect(tmpdir.join('foo/bar.txt').read).to eq("Bar's text")
      expect(tmpdir.join('foo/baz.txt').read).to eq("Baz's text")

      expect(assets_config.precompile).to include('foo/baz.txt')
      expect(assets_config.precompile).to_not include('foo/bar.txt')
    end
  end
end
