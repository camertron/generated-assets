# encoding: UTF-8

module GeneratedAssets
  class Manifest
    attr_reader :app, :prefix, :entries
    attr_reader :before_hooks, :after_hooks

    def initialize(app, prefix)
      @app = app
      @prefix = prefix
      @entries = []
      @before_hooks = []
      @after_hooks = []
    end

    def add(logical_path, options = {}, &block)
      entries << Entry.new(logical_path, block, options)
    end

    def apply!
      before_hooks.each(&:call)

      write_files
      add_precompile_paths

      after_hooks.each(&:call)
    end

    def before_apply(&block)
      before_hooks << block
    end

    def after_apply(&block)
      after_hooks << block
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
