# encoding: UTF-8

module GeneratedAssets
  class Railtie < ::Rails::Railtie
    config.before_configuration do |app|
      app.config.assets.generated = GeneratedAssets::Manifest.new(
        app, File.join(GeneratedAssets.asset_dir, RailtieHelper.app_name_for(app))
      )
    end

    config.after_initialize do |app|
      app.config.assets.generated.apply!
    end

    initializer :generated_assets, group: :all do |app|
      app.config.assets.paths << File.join(
        GeneratedAssets.asset_dir, RailtieHelper.app_name_for(app)
      )
    end
  end

  module RailtieHelper
    def self.app_name_for(app)
      case app
        when Class               # rails 5
          app.parent_name
        else
          app.class.parent_name  # rails 4
      end
    end
  end
end
