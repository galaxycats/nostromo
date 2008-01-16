module ActiveRecord
  module Acts
    module Authenticatable
      def self.included(base) # :nodoc:
        begin
          Digest::SHA1
        rescue
          require 'digest/sha1'
        end
        
        base.extend ClassMethods
      end

      module ClassMethods
        
        def acts_as_authenticatable(options = {})
          unless authenticatable? # don't let AR call this twice
            cattr_accessor :login
            
            # email as default login
            self.login = options[:login] || :email
            validates_presence_of self.login
            validates_length_of self.login, :within => 3..100
            
            validates_format_of :new_email, :allow_nil => true,
              :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,  
              :if => Proc.new { |user| !user.new_email.nil? }
            
            validates_presence_of :security_token, :if => Proc.new { |user| !user.verified? }
            validates_presence_of :token_expiry, :if => Proc.new { |user| !user.verified? }
            validates_presence_of :password, :if => :new_record?
            validates_confirmation_of :password, :if => :new_record?
            validates_length_of :password, :within => 5..40, :if => :new_record_password_should_be_changed, :message => "password_at_least_5_chars"
            
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

        def try_change_email(new_email, confirm_email)
          if new_email.length > 0 && new_email == confirm_email 
            self.new_email = new_email
            create_security_token_and_its_expiry_date(true)
            self.save
          end
        end

        def change_password(pass, confirm = nil)
          return if confirm && confirm != pass
          @new_password = true
          self.password = pass
          crypt_password
        end
        
        def verify_by_token(token)
          if token == self.security_token && self.token_expiry >= Time.now.to_date
            if !self.verified
              self.verified = true
            elsif self.new_email
              self.email = self.new_email
              self.new_email = nil
            end
            self.save
            self
          else
            return nil
          end
        end
        
        protected
          def generate_salt
            self.salt = "#{rand.to_s}-salt-ljkhcawb4-#{Time.now}"
          end
          
          def crypt_password
            self.salted_password = self.class.hashed(self.password, generate_salt) if new_record? || @new_password
          end
          
          def create_security_token_and_its_expiry_date(force_new = false)
            if new_record? || force_new
              set_token_expiry(Authenticatable.const_defined?("TOKEN_LIFETIME") ? TOKEN_LIFETIME : 1.day)
              set_security_token
            end
          end

          def set_security_token
            self.security_token = Digest::SHA1.hexdigest(self.token_expiry.to_s + rand.to_s)
          end
          
          def set_token_expiry(lifetime)
            self.token_expiry = (Time.now + lifetime).to_date
          end
        
        private
          
          def verified=(val)
            write_attribute("verified", val)
          end
          
          def new_record_password_should_be_changed
            self.new_record? || @new_password
          end
          
        module ClassMethods
          def authenticate(login_credential, password)
            # logger.debug("##### login_credential: #{login_credential}")
            # logger.debug("##### login: #{login}")
            u = send("find_by_#{login}_and_verified", login_credential, true)
            # logger.debug("##### u: #{u.inspect}")
            (u && u.salted_password == hashed(password, u.salt)) ? u : nil
          end
          
          def verify(login, token)
            u = send("find_by_#{self.login}", login).verify_by_token(token)
          end

          def hashed(str, salt)
            Digest::SHA1.hexdigest("#{salt}#{str}")
          end        
        end
          
      end
    end
  end
end