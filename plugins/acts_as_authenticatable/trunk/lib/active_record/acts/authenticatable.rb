module ActiveRecord
  module Acts
    module Authenticatable
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        
        def acts_as_authenticatable(options = {})
          unless authenticatable? # don't let AR call this twice
            cattr_accessor :login
            self.login = options[:login] || :email
            
            validates_presence_of :security_token
            validates_presence_of :token_expiry
            validates_presence_of :email # TODO
            validates_presence_of :password, :if => :new_record?
            validates_confirmation_of :password, :if => :new_record?
            validates_length_of :email, :within => 3..100
            validates_length_of :password, :within => 5..40, :if => :new_record?, :message => "password_at_least_5_chars"
            
            before_validation :create_security_token_and_its_expiry_date
            after_validation :crypt_password
          end
          include InstanceMethods
        end
        
        def authenticatable?
          self.included_modules.include?(InstanceMethods)
        end
      end
      
      module InstanceMethods
        
        attr_accessor :password
        
        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        def token_expired?
          # self.security_token and self.token_expiry and (Time.now > self.token_expiry)
        end

        def update_expiry
          # write_attribute('token_expiry', [self.token_expiry, Time.at(Time.now.to_i + 600 * 1000)].min)
          # write_attribute('authenticated_by_token', true)
          # write_attribute("verified", 1)
          # update_without_callbacks
        end

        def set_delete_after
          # hours = UserSystem::CONFIG[:delayed_delete_days] * 24
          # write_attribute('deleted', 1)
          # write_attribute('delete_after', Time.at(Time.now.to_i + hours * 60 * 60))
          # 
          # # Generate and return a token here, so that it expires at
          # # the same time that the account deletion takes effect.
          # return generate_security_token(hours)
        end

        def change_password(pass, confirm = nil)
          # self.password = pass
          # self.password_confirmation = confirm.nil? ? pass : confirm
          # @new_password = true
        end
        
        def verify_by_token(token)
          if token == self.security_token && self.token_expiry >= Time.now.to_date
            self.verified = true
            return self.save
          else
            return nil
          end
        end
        
        protected
          def generate_salt
            self.salt = "#{rand.to_s}-salt-ljkhcawb4-#{Time.now}"
          end
          
          def crypt_password
            self.salted_password = self.class.hashed(self.password, generate_salt) if new_record? # || @new_password
          end
          
          def create_security_token_and_its_expiry_date
            if new_record?
              set_token_expiry(Authenticatable.const_defined?("TOKEN_LIFETIME") ? TOKEN_LIFETIME : 1.day)
              self.security_token = Digest::SHA1.hexdigest(self.token_expiry.to_s + rand.to_s)
            end
          end

          def new_security_token(hours = nil)
            # write_attribute('security_token', self.class.hashed(self.salted_password + Time.now.to_i.to_s + rand.to_s))
            # write_attribute('token_expiry', Time.at(Time.now.to_i + token_lifetime(hours)))
            # update_without_callbacks
            # return self.security_token
          end
          
          def set_token_expiry(lifetime)
            self.token_expiry = (Time.now + lifetime).to_date
          end
        
        private
          
          def verified=(val)
            write_attribute("verified", val)
          end
          
          
        module ClassMethods
          def authenticate(login_credential, password)
            u = send("find_by_#{login}_and_verified", login_credential, true)
            (u && u.salted_password == hashed(password, u.salt)) ? u : nil
          end
          
          def verify(email, token)
            u = send("find_by_#{login}", email).verify_by_token(token)
          end

          def hashed(str, salt)
            Digest::SHA1.hexdigest("#{salt}#{str}")
          end        
        end
          
      end
    end
  end
end