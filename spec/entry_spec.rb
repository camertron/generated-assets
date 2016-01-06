# encoding: UTF-8

require 'spec_helper'

include GeneratedAssets

describe Entry do
  let(:entry) do
    Entry.new(logical_path, callback)
  end

  let(:callback) do
    -> { 'Callback contents' }
  end

  let(:logical_path) do
    'foo/bar.txt'
  end

  describe '#precompile?' do
    it 'indicates no precompilation' do
      expect(entry.precompile?).to eq(false)
    end
  end

  describe '#write_to' do
    it 'writes the file to the given path' do
      entry.write_to(tmpdir)
      absolute_path = tmpdir.join(logical_path)
      files = Dir.glob(tmpdir.join('**', '**'))
      expect(files).to include(absolute_path.to_s)
      contents = File.read(absolute_path)
      expect(contents).to eq(callback.call)
    end
  end

  context 'with an entry that should be precompiled' do
    let(:entry) do
      Entry.new('foo/bar.txt', nil, precompile: true)
    end

    describe '#precompile?' do
      it 'indicates precompilation' do
        expect(entry.precompile?).to eq(true)
      end
    end
  end
end
