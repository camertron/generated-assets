# encoding: UTF-8

require 'yaml'
require 'json'

module GeneratedAssets
  class RailsManifest
    class << self
      def load_for(app)
        asset_path = asset_path_for(app)

        [YamlManifest, JsonManifest].each do |klass|
          if manifest_file = klass.find_in(asset_path)
            return klass.load_file(manifest_file)
          end
        end
      end

      private

      def asset_path_for(app)
        Pathname(
          File.join(Rails.public_path, app.config.assets.prefix)
        )
      end
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end
  end

  class YamlManifest < RailsManifest
    class << self
      def find_in(path)
        Dir.glob(File.join(path, 'manifest.yml')).first
      end

      def load_file(file)
        load(File.read(file))
      end

      def load(raw)
        new(YAML.load(raw))
      end
    end

    def files
      data
    end

    def find_by_logical(logical_path)
      files[logical_path]
    end
  end

  class JsonManifest < RailsManifest
    class << self
      def find_in(path)
        Dir.glob(File.join(path, '.*sprockets-manifest*.json')).first
      end

      def load_file(file)
        load(File.read(file))
      end

      def load(raw)
        new(JSON.parse(raw))
      end
    end

    def files
      data['files']
    end

    def find_by_logical(logical_path)
      files.each_pair do |digest_file, attributes|
        if attributes['logical_path'] == logical_path
          return digest_file
        end
      end

      nil
    end
  end
end
