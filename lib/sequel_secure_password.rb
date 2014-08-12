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
      # * :include_validations - when set to false, password present and
      # confirmation validations won't be included. Default: true
      def self.configure(model, options = {})
        model.instance_eval do
          @cost                = options.fetch(:cost, BCrypt::Engine::DEFAULT_COST)
          @include_validations = options.fetch(:include_validations, true)
        end
      end

      module ClassMethods
        attr_reader :cost, :include_validations
        Plugins.inherited_instance_variables(self, :@cost                => nil,
                                                   :@include_validations => true)
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

          if model.include_validations
            errors.add :password, 'is not present'      if SecurePassword.blank_string? password_digest
            errors.add :password, 'has no confirmation' if SecurePassword.blank_string? password_confirmation
            errors.add :password, 'doesn\'t match confirmation' if password != password_confirmation
          end
        end
      end
    end
  end
end

