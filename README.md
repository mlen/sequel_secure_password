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

Plugin should be used in subclasses of `Sequel::Model`.
__Always__ call super in `validate` method of your model, otherwise password
validations won't be executed.
It __does not__ `set_allowed_columns` and mass assignment policy must be managed
separately.

Example model:

    class User < Sequel::Model
      plugin :secure_password
    end

    # cost option can be used to change computational complexity of BCrypt
    class HighCostUser < Sequel::Model
      plugin :secure_password, cost: 12
    end

    # include_validations option can be used to disable default password
    # presence and confirmation
    class UserWithoutValidations < Sequel::Model
      plugin :secure_password, include_validations: false
    end

    # digest_column option can be used to use an alternate database column.
    # the default column is "password_digest"
    class UserWithAlternateDigestColumn < Sequel::Model
      plugin :secure_password, digest_column: :password_hash
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

1. Open an issue
2. Discuss proposed change
3. Once we both agree on the change I'll implement it or if you want it really
   badly, fork the project and create a pull request.

## Thanks

Thanks to [@send](https://github.com/send) for implementing the `:cost` option
and to [@badosu](https://github.com/badosu) for motivating me to add
`:include_validations` option.
