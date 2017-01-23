require 'bundler/setup'
require 'rubygems/tasks'
require 'rspec/core/rake_task'

# building and local installation
Gem::Tasks::Install.new
Gem::Tasks::Build::Gem.new

# git-related tasks
Gem::Tasks::SCM::Status.new
Gem::Tasks::SCM::Tag.new(format: '%s', sign: true)
Gem::Tasks::SCM::Push.new

# pushing to gemcutter
Gem::Tasks::Push.new
Gem::Tasks::Release.new

# loading gem into the console
Gem::Tasks::Console.new

# spec tasks
RSpec::Core::RakeTask.new(:spec)
