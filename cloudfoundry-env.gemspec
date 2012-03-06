# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudfoundry/version"

Gem::Specification.new do |s|
  s.name        = "cloudfoundry-env"
  s.version     = Cloudfoundry::Environment::VERSION
  s.authors     = ["ciberch"]
  s.email       = ["monica.keller@gmail.com"]
  s.homepage    = "https://github.com/cloudfoundry-samples/cloudfoundry-env"
  s.summary     = "Ruby Apps can use gem to parse the Cloud Foundry Environment"
  s.description = "App Name, App Owner, Port Number, Host, Services, Instances"

  s.rubyforge_project = "cloudfoundry-env"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "hashie"
end
