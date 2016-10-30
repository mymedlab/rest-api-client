# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rest_api_client/version"

Gem::Specification.new do |spec|
  spec.name          = "rest_api_client"
  spec.version       = RestApiClient::VERSION
  spec.authors       = ["Casey Provost"]
  spec.email         = ["provost.design@gmail.com"]

  spec.summary       = %q{Interface with REST apis a little bit easier.}
  spec.description   = %q{
    After interfacing with about 7 REST apis in similar ways I got fed up with the duplication
    and extracted it here. It requires strict entity attribute definitions, loose definitions around
    resource interaction, and all kinds of cool stuff.
  }
  spec.homepage      = "https://github.com/caseyprovost/rest-api-client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("bundler", "~> 1.13")
  spec.add_development_dependency("rake", "~> 11.3")
  spec.add_development_dependency("rspec", "~> 3.5")

  spec.add_dependency("httparty", "0.14")
  spec.add_dependency("activesupport", ">= 3.0")
end
