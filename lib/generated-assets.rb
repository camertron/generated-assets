# encoding: UTF-8

require 'fileutils'
require 'generated-assets/railtie'
require 'securerandom'
require 'tmpdir'

module GeneratedAssets
  autoload :Entry,         'generated-assets/entry'
  autoload :Manifest,      'generated-assets/manifest'
  autoload :Processor,     'generated-assets/processor'
  autoload :RailsManifest, 'generated-assets/rails_manifest'

  class << self
    def asset_dir
      @asset_dir ||= begin
        dir = File.join(Dir.tmpdir, SecureRandom.hex)
        FileUtils.mkdir_p(dir)
        dir
      end
    end
  end
end
