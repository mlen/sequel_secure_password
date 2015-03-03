# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel_secure_password/version'

Gem::Specification.new do |gem|
  gem.name          = "sequel_secure_password"
  gem.version       = SequelSecurePassword::VERSION
  gem.authors       = ["Mateusz Lenik"]
  gem.email         = ["gems@mlen.pl"]
  gem.description   = %q{Plugin adds authentication methods to Sequel models using BCrypt library.}
  gem.summary       = <<EOF
Plugin adds BCrypt authentication and password hashing to Sequel models.
Model using this plugin should have 'password_digest' field.

This plugin was created by extracting has_secure_password strategy from rails.
EOF
  gem.homepage      = "http://github.com/mlen/sequel_secure_password"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'bcrypt',      ['>= 3.1', '< 4.0']
  gem.add_dependency 'sequel',      ['>= 4.1.0', '< 5.0']

  gem.add_development_dependency 'rspec',          '~> 2.14'
  gem.add_development_dependency 'rake',           '~> 10'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'pry'
  if RUBY_PLATFORM == "java"
    gem.add_development_dependency 'jdbc-sqlite3', '~> 3.7.2'
  else
    gem.add_development_dependency 'sqlite3', '~> 1.3.0'
  end
end
