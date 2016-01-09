## generated-assets
Programmatically generate assets for the Rails asset pipeline.

## Installation

`gem install generated-assets`

or put it in your Gemfile:

```ruby
gem 'generated-assets'
```

This gem is designed to work with Rails. Adding it to your Gemfile should be enough to add it to your project - you shouldn't need to manually require it.

### Rationale

The Rails asset pipeline is great, but not super extensible. Generally speaking, any file you want it to recognize has to be on disk somewhere. That's pretty limiting, especially if you have a bunch of similar resources you'd like to add, but don't want to create individual files for. A great example is translations in Javascript. You probably don't want to include the translations for every locale in your Javascript bundle. Wouldn't it be nice if you could iterate over a list of locales and add translation files programmatically? This gem can help.

### Getting Started

The generated-assets gem adds an attribute called `generated` to the Rails configuration object. Adding assets is easy:

```ruby
# config/application.rb

I18n.available_locales.each do |locale|
  config.assets.generated.add("translations-#{locale}.js") do
    "window.translations ||= {}; window.translations.#{locale} = { ... }"
  end
end
```

The `add` method expects to be given the path of the new asset and a block. The return value of the block gets written inside the new asset file.

### Asset Precompilation

The gem also supports adding any generated assets to your application's precompile list. Just include `precompile: true`:

```ruby
config.assets.generated.add("my_asset.css", precompile: true) do
  ...
end
```

### How Does it Work?

Under the covers, generated-assets creates a temporary directory that it adds to the asset pipeline's load path. It then writes each file you've requested to the temporary directory. As far as the asset pipeline is concerned, those files are accessible and available as if they lived in your `app/assets` directory.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* Cameron C. Dutro: http://github.com/camertron
