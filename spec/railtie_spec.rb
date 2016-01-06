# encoding: UTF-8

require 'spec_helper'

include GeneratedAssets

describe Railtie do
  let(:assets_config) do
    app.config.assets
  end

  it 'sets up the manifest' do
    expect(assets_config.generated).to be_a(Manifest)
  end

  it 'adds the generated asset path to the list of asset paths' do
    expect(assets_config.paths).to include(assets_config.generated.prefix)
  end
end
