# Sequel secure_password [![Build Status](https://secure.travis-ci.org/mlen/sequel_secure_password.png)](http://travis-ci.org/mlen/sequel_secure_password) [![Dependency Status](https://gemnasium.com/mlen/sequel_secure_password.png)](https://gemnasium.com/mlen/sequel_secure_password)

Plugin adds BCrypt authentication and password hashing to Sequel models.
Model using this plugin should have `password_digest` field.

This plugin was created by extracting `has_secure_password` strategy from rails.

## Installation

Add this line to your application's Gemfile:

    gem 'sequel_secure_password'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_secure_password

## Usage

Plugin should be used in subclasses of `Sequel::Model`. The model should have
`password_digest` attribute in database.  
__Always__ call super in `validate` method of your model, otherwise password
validations won't be executed.  
It __does not__ `set_allowed_columns` and mass assignment policy must be managed
separately.

Example model:

    class User < Sequel::Model
      plugin :secure_password
    end

    user = User.new
    user.password = "foo"
    user.password_confirmation = "bar"
    user.valid? # => false

    user.password_confirmation = "foo"
    user.valid? # => true

    user.authenticate("foo") # => user
    user.authenticate("bar") # => nil

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
