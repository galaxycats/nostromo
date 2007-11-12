# Define the class against we want to test the configuration
class Account < ActiveRecord::Base
  acts_as_authenticatable :login => :account_number
end
