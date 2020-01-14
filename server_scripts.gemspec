#coding: utf-8
$:.unshift File.expand_path("../lib", __FILE__)

require 'server_scripts/version.rb'

def self.get_files
  files = []
  ['ext', 'lib', 'spec'].each do |folder|
    files.concat Dir.glob "#{folder}/**/*"
  end

  files.concat(
    ["CONTRIBUTING.md", "Gemfile", "server_scripts.gemspec",
     "README.md", "Rakefile"])
  
  files
end
files = get_files

ServerScripts::DESCRIPTION = <<MSG
Easily write scripts for submitted jobs to various machines.
MSG

Gem::Specification.new do |spec|
  spec.name          = 'xnd'
  spec.version       = ServerScripts::VERSION
  spec.authors       = ['Sameer Deshmukh']
  spec.email         = ['sameer.deshmukh93@gmail.com']
  spec.summary       = %q{Easily write scripts for submitted jobs to various machines.}
  spec.description   = ServerScripts::DESCRIPTION
  spec.homepage      = "https://github.com/v0dro/server-scripts"
  spec.license       = 'BSD-3 Clause'

  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-hooks'
  spec.add_development_dependency 'minitest-fail-fast'
end
