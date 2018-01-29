# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spagett/version"

Gem::Specification.new do |spec|
  spec.name          = "spagett"
  spec.version       = Spagett::VERSION
  spec.authors       = ["Neil Johari"]
  spec.email         = ["neil@johari.tech"]

  spec.summary       = %q{Slack support bot for syosseths.com}
  spec.homepage      = "https://github.com/Syosset/spagett"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "sinatra", "~> 2.0"
  spec.add_dependency "slack-ruby-client", "~> 0.11"
end
