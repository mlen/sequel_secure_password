require "sequel_secure_password/version"
require "bcrypt"

module Sequel
  module Plugins
    module SecurePassword
      def self.blank_string?(string)
        string.nil? or string =~ /\A\s*\z/
      end

      # Configure the plugin by setting the available options. Options:
      # * :cost - the cost factor when creating password hash. Default:
      # BCrypt::Engine::DEFAULT_COST(10)
      def self.configure(model, options = {})
        model.instance_eval do
          @cost = options.fetch(:cost, BCrypt::Engine::DEFAULT_COST)
        end
      end

      module ClassMethods
        attr_reader :cost
        Plugins.inherited_instance_variables(self, :@cost => nil)
      end

      module InstanceMethods
        attr_accessor :password_confirmation
        attr_reader   :password

        def password=(unencrypted)
          @password = unencrypted
          unless SecurePassword.blank_string? unencrypted
            self.password_digest = BCrypt::Password.create(unencrypted, :cost => model.cost)
          end
        end

        def authenticate(unencrypted)
          if BCrypt::Password.new(password_digest) == unencrypted
            self
          end
        end

        def validate
          super

          errors.add :password, 'is not present'      if SecurePassword.blank_string? password_digest
          errors.add :password, 'has no confirmation' if password != password_confirmation
        end

        private

      end
    end
  end
end

