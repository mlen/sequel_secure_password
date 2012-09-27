# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel_secure_password/version'

Gem::Specification.new do |gem|
  gem.name          = "sequel_secure_password"
  gem.version       = SequelSecurePassword::VERSION
  gem.authors       = ["Mateusz Lenik"]
  gem.email         = ["mt.lenik@gmail.com"]
  gem.description   = %q{Plugin adds authentication methods to Sequel models using BCrypt library.}
  gem.summary       = <<EOF
Plugin adds BCrypt authentication and password hashing to Sequel models.
Model using this plugin should have 'password_digest' field.

This plugin was created by extracting has_secure_password strategy from rails.
EOF
  gem.homepage      = "http://github.com/mlen/sequel_secure_password"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'bcrypt-ruby', '~> 3.0.0'
  gem.add_dependency 'sequel',      '~> 3.40.0'

  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'rake',  '~> 0.9.0'
  if RUBY_PLATFORM == "jruby"
    gem.add_development_dependency 'jdbc-sqlite3', '~> 3.7.2'
  else
    gem.add_development_dependency 'sqlite3', '~> 1.3.0'
  end
end
