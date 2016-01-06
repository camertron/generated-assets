# encoding: UTF-8

require 'spec_helper'
require 'helpers/rails_manifest'
require 'pathname'

include GeneratedAssets

describe 'precompilation' do
  let(:assets_config) do
    app.config.assets
  end

  let(:asset_path) do
    Pathname(
      File.join(Rails.public_path, assets_config.prefix)
    )
  end

  it 'precompiles generated assets correctly' do
    assets_config.generated.add('foo/bar.txt', precompile: true) do
      'bar text'
    end

    assets_config.generated.apply!

    begin
      Rake::Task['assets:precompile:primary'].invoke
      Rake::Task['assets:precompile:nondigest'].invoke
    rescue RuntimeError
      Rake::Task['assets:precompile'].invoke
    end

    rails_manifest = RailsManifest.load_for(app)
    digest_file = rails_manifest.find_by_logical('foo/bar.txt')

    expect(digest_file).to_not be_nil
    contents = asset_path.join(digest_file).read
    expect(contents).to eq('bar text')
  end
end
