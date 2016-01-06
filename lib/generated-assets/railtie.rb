# encoding: UTF-8

module GeneratedAssets
  class Railtie < ::Rails::Railtie
    config.before_configuration do |app|
      app.config.assets.generated = GeneratedAssets::Manifest.new(
        app, File.join(GeneratedAssets.asset_dir, app.class.parent_name)
      )
    end

    config.after_initialize do |app|
      if app.config.assets.compile
        app.config.assets.generated.apply!
      end
    end

    initializer :i18n_js_assets, group: :all do |app|
      if app.config.assets.compile
        app.config.assets.paths << File.join(
          GeneratedAssets.asset_dir, app.class.parent_name
        )
      end
    end
  end
end
