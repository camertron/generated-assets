# encoding: UTF-8

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
        locales_dir = "#{::Rails.root}/config/locales"
        locales = Dir.entries(locales_dir).select {|locale| File.extname(locale) == ".yml"}
        mtime_paths = locales.map do |locale|
          mtime = File.mtime("#{locales_dir}/#{locale}")
        end
        dir_name = mtime_paths.join("")
        File.join(Dir.tmpdir, Digest::SHA256.new.hexdigest(dir_name))
      end
    end
  end
end
