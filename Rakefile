require 'rake'
require 'rake/testtask'
require 'fileutils'
require 'server_scripts/version.rb'

gemspec = eval(IO.read("server_scripts.gemspec"))

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/test_*.rb']
end
