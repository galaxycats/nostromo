# Define the class against we want to test
class User < ActiveRecord::Base
  acts_as_authenticatable
end
