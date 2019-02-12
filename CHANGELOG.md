2.1.3
===
* Apply generated assets when precompiling, and allow applying to be enabled manually by setting `config.assets.generated.compile = true`.

2.1.2
===
* Use File.binwrite instead of File.write to avoid encoding issues.

2.1.1
===
* Don't apply generated assets if asset compilation is turned off (i.e. if
  config.assets.compile is false).

2.1.0
===
* Support for Rails 5.

2.0.0
===
* Use static instead of randomly generated directory name.

1.1.1
===
* Delay creating a temp directory until assets are actually written.

1.1.0
===
* Removing config check causing assets to not get compiled in production.

1.0.1
===
* Removing tilt as a dependency.

1.0.0
===
Birthday!
