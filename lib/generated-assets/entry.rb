# encoding: UTF-8

require 'fileutils'

module GeneratedAssets
  class Entry
    DEFAULT_PROC = Proc.new { '' }

    attr_reader :logical_path, :callback, :options

    def initialize(logical_path, callback, options = {})
      @logical_path = logical_path
      @callback = callback || DEFAULT_PROC
      @options = options
    end

    def precompile?
      @options.fetch(:precompile, false)
    end

    def write_to(prefix)
      path = File.join(prefix, logical_path)
      FileUtils.mkdir_p(File.dirname(path))
      File.binwrite(path, callback.call)
    end
  end
end
