require 'rubygems'
require 'bundler'
Bundler.setup
require 'sequel'

RSpec.configure do |c|
  c.before :suite do
    Sequel::Model.plugin(:schema)
    Sequel.connect 'sqlite:/'

    class User < Sequel::Model
      set_schema do
        primary_key :id
        varchar     :password_digest
      end
    end

    User.create_table!
  end

  c.around :each do |example|
    Sequel::Model.db.transaction(:rollback => :always) { example.run }
  end
end


