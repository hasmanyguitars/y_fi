$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "y_fi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "y_fi"
  s.version     = YFi::VERSION
  s.authors     = ["Jeff Ramer"]
  s.email       = ["jeffery.ramer@gmail.com"]
  s.summary     = "Gem for fetching quotes from the Yahoo Finance API"
  s.description = "https://developer.yahoo.com/yql/faq/"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "httparty", "~> 0.13.7"
  s.add_development_dependency "rspec", "~> 3.5.0"
end
