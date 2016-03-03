# encoding: UTF-8

require 'spec_helper'
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

  let(:prefix) do
    Pathname(assets_config.generated.prefix)
  end

  def run_precompile_task
    begin
      Rake::Task['assets:precompile:primary'].invoke
      Rake::Task['assets:precompile:nondigest'].invoke
    rescue RuntimeError
      Rake::Task['assets:precompile'].invoke
    end
  end

  it 'precompiles generated assets correctly' do
    assets_config.generated.add('foo/bar.txt', precompile: true) do
      'bar text'
    end

    expect(prefix).to_not exist
    assets_config.generated.apply!
    expect(prefix).to exist

    run_precompile_task

    rails_manifest = RailsManifest.load_for(app)
    digest_file = rails_manifest.find_by_logical('foo/bar.txt')

    expect(digest_file).to_not be_nil
    contents = asset_path.join(digest_file).read
    expect(contents).to eq('bar text')
  end

  it 'does not create a temp directory if no assets have been added' do
    expect(prefix).to_not exist
    assets_config.generated.apply!
    expect(prefix).to_not exist
    run_precompile_task
    expect(prefix).to_not exist
  end
end
