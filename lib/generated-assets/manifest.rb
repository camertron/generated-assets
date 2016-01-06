# encoding: UTF-8

module GeneratedAssets
  class Manifest
    attr_reader :app, :prefix, :entries

    def initialize(app, prefix)
      @app = app
      @prefix = prefix
      @entries = []
    end

    def add(logical_path, options = {}, &block)
      entries << Entry.new(logical_path, block, options)
    end

    def apply!
      write_files
      add_precompile_paths
    end

    private

    def write_files
      entries.each do |entry|
        entry.write_to(prefix)
      end
    end

    def add_precompile_paths
      entries.each do |entry|
        if entry.precompile?
          app.config.assets.precompile << entry.logical_path
        end
      end
    end
  end
end
