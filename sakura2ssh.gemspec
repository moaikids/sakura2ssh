# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sakura2ssh/version"

Gem::Specification.new do |s|
  s.name        = "sakura2ssh"
  s.version     = Sakura2ssh::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["moaikids"]
  s.email       = ["moaikids@gmail.com"]
  s.homepage    = "http://github.com/moaikids/sakura2ssh"
  s.summary     = %q{A ssh_config manager for Sakura Cloud}
  s.description = %q{sakura2ssh is a ssh_config manager for Sakura Cloud}

  s.rubyforge_project = "sakura2ssh"
  s.add_dependency "thor", "~> 0.14.6"
  s.add_dependency "httpclient", "~> 2.3.4.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
