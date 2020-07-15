$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'generated-assets/version'

Gem::Specification.new do |s|
  s.name     = "generated-assets"
  s.version  = ::GeneratedAssets::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = 'Programmatically generate assets for the Rails asset pipeline.'

  s.platform = Gem::Platform::RUBY

  if ENV['RAILS_VERSION']
    s.add_dependency 'railties', "~> #{ENV['RAILS_VERSION']}"
  else
    s.add_dependency 'railties', '>= 3.2'
  end

  s.add_dependency 'sprockets-rails'
  s.add_dependency 'tzinfo'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "README.md", "Rakefile", "generated-assets.gemspec"]
end
