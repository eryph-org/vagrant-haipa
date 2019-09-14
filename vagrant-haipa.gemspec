# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-haipa/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-haipa"
  gem.version       = VagrantPlugins::Haipa::VERSION
  gem.authors       = ["Haipa contributors"]
  gem.email         = ["package-maintainers@haipa.io"]
  gem.description   = %q{Enables Vagrant to manage Hyper-V with Haipa}
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "log4r"
  gem.add_dependency "haipa_compute", ">= 0.1.0"
end
