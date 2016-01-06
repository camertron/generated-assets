# encoding: UTF-8

$:.push(File.dirname(__FILE__))

require 'rspec'
require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'pry-nav'

require 'rails'
require 'rake'
require 'sprockets/railtie'

ENV['RAILS_ENV'] ||= 'test'

require 'generated-assets'

Dir.chdir('spec') do
  require File.expand_path('../config/application', __FILE__)
  GeneratedAssets::DummyApplication.initialize!
  GeneratedAssets::DummyApplication.load_tasks  # used by precompilation specs
end

module LetDeclarations
  extend RSpec::SharedContext

  let(:tmpdir) do
    Pathname(Dir.mktmpdir)
  end

  let(:app) do
    Rails.application
  end
end

RSpec.configure do |config|
  config.include(LetDeclarations)

  config.before(:each) do
    FileUtils.rm_rf(
      GeneratedAssets::DummyApplication.root.join('tmp').to_s
    )

    FileUtils.rm_rf(
      GeneratedAssets::DummyApplication.root.join('public').to_s
    )

    FileUtils.rm_rf(
      app.config.assets.generated.prefix
    )

    app.config.assets.generated.entries.clear
  end

  config.after(:each) do
    FileUtils.rm_rf(tmpdir)
  end
end
