# encoding: UTF-8

require 'fileutils'

module GeneratedAssets
  class Manifest
    attr_reader :app, :prefix, :entries
    attr_reader :before_hooks, :after_hooks

    # Force generated-assets to write files and add stuff to the precompile
    # list. It works similarly to config.assets compile, but applies only to
    # generated assets. Under normal circumstances, generated-assets will
    # detect when it should do these things for you, usually when
    # 1) config.assets.compile is true, or 2) when running
    # rake assets:precompile. If you've got a non-standard setup though,
    # set this property to a truthy value when you're compiling assets or
    # running your app in an environment (i.e. development) that requires
    # generated assets to be available.
    attr_accessor :compile

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
      return unless should_apply?
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
      ensure_prefix_dir_exists unless entries.empty?

      entries.each do |entry|
        entry.write_to(prefix)
      end
    end

    def should_apply?
      app.config.assets.compile ||
      compile || (
        defined?(::Rake) &&
          ::Rake.respond_to?(:application) &&
          ::Rake.application.respond_to?(:top_level_tasks) &&
          ::Rake.application.top_level_tasks.include?('assets:precompile')
      )
    end

    def ensure_prefix_dir_exists
      FileUtils.mkdir_p(prefix)
    end

    def add_precompile_paths
      entries.each do |entry|
        if entry.precompile?
          app.config.assets.precompile << remove_extra_extensions(
            entry.logical_path
          )
        end
      end
    end

    def remove_extra_extensions(path)
      until File.extname(path).empty?
        ext = File.extname(path)
        path = path.chomp(ext)
      end

      "#{path}#{ext}"
    end
  end
end
