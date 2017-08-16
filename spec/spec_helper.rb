require 'rubygems'
require 'bundler'
Bundler.setup

require 'sequel'
require 'sequel/extensions/migration'
require 'sequel/plugins/secure_password'

adapter = RUBY_PLATFORM == 'java' ? 'jdbc:sqlite::memory:' : 'sqlite:/'

RSpec.configure do |c|
  c.before :suite do
    Sequel::Model.db = Sequel.connect(adapter)

    Sequel.migration do
      up do
        create_table(:users) do
          primary_key :id
          varchar     :password_digest
        end

        create_table(:high_cost_users) do
          primary_key :id
          varchar     :password_digest
        end

        create_table(:user_without_validations) do
          primary_key :id
          varchar     :password_digest
        end

        create_table(:user_with_alternate_digest_columns) do
          primary_key :id
          varchar     :password_hash
        end
      end
    end.apply(Sequel::Model.db, :up)

    class User < Sequel::Model
      plugin :secure_password
    end

    class HighCostUser < Sequel::Model
      plugin :secure_password, cost: 12
    end

    class UserWithoutValidations < Sequel::Model
      plugin :secure_password, include_validations: false
    end

    class UserWithAlternateDigestColumn < Sequel::Model
      plugin :secure_password, digest_column: :password_hash
    end
  end

  c.around(:each) do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
end
