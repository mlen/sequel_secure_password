require 'rubygems'
require 'bundler'
Bundler.setup

require 'sequel'
require 'sequel_secure_password'

adapter = RUBY_PLATFORM == "java" ? 'jdbc:sqlite::memory:' : 'sqlite:/'

RSpec.configure do |c|
  c.before :suite do
    Sequel::Model.plugin(:schema)
    Sequel.connect adapter

    class User < Sequel::Model
      set_schema do
        primary_key :id
        varchar     :password_digest
      end

      plugin :secure_password
    end

    class HighCostUser < Sequel::Model
      set_schema do
        primary_key :id
        varchar     :password_digest
      end

      plugin :secure_password, cost: 12
    end

    class UserWithoutValidations < Sequel::Model
      set_schema do
        primary_key :id
        varchar     :password_digest
      end

      plugin :secure_password, include_validations: false
    end

    User.create_table!
    HighCostUser.create_table!
    UserWithoutValidations.create_table!
  end

  c.around :each do |example|
    Sequel::Model.db.transaction(:rollback => :always) { example.run }
  end
end


