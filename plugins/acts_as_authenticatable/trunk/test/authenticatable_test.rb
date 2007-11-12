require 'test/test_helper'
require 'test/user'
require 'test/account'

class UserTest < Test::Unit::TestCase

  fixtures :users, :accounts

  def test_create_new_user_and_verify
    user = User.new(:email => 'hans_wurst@hund.com')
                    
    assert user.new_record?
    user.password = "dolles_password"
    user.password_confirmation = "dolles_password"
    assert user.save, user.errors.full_messages
    
    new_user = User.authenticate("hans_wurst@hund.com", "dolles_password")
    assert_nil new_user
    
    User.verify(user.email, user.security_token)
  end

  def test_should_set_security_token_and_expiry_upon_creation
    user = User.new(:email => 'hans_wurst@hund.com')
    assert user.new_record?
    user.password = "a_password_test"
    user.password_confirmation = "a_password_test"
    assert user.valid?, user.errors.full_messages
    assert_not_nil user.security_token
    assert_not_nil user.token_expiry
    assert_equal (Time.now + 1.day).to_date, user.token_expiry
  end
  
  def test_should_not_change_security_token_if_record_is_not_new
    jessie = users(:jessie)
    assert_not_nil jessie
    old_token = jessie.security_token
    old_expiry = jessie.token_expiry
    jessie.lastname = "Spring"
    assert jessie.save, jessie.errors.full_messages
    assert_equal old_token, jessie.security_token
    assert_equal old_expiry, jessie.token_expiry
  end
  
  def test_create_new_verified_user
    user = User.new(:email => 'jenna.jamesson@boobs.com')
                    
    assert user.new_record?
    user.password = "a_password_test"
    user.password_confirmation = "a_password_test"
    user.send("verified=", 1)
    assert user.save, user.errors.full_messages
    
    new_user = User.authenticate("jenna.jamesson@boobs.com", "a_password_test")
    assert_not_nil new_user
    assert_kind_of(User, new_user)
  end
  
  def test_valid_user
    jessie = users(:jessie)
    assert jessie.valid?
  end
  
  def test_should_authenticate_with_email_and_password
    jessie = User.authenticate(users(:jessie).email, 'alongtest')
    assert_not_nil jessie
    assert_kind_of(User, jessie)
    assert_equal users(:jessie), jessie
  end
  
  def test_should_authenticate_with_something_else_and_password
    krystal = Account.authenticate(accounts(:krystal).account_number, 'alongtest')
    assert_not_nil krystal
    assert_kind_of(Account, krystal)
    assert_equal accounts(:krystal), krystal
  end
  
  def test_not_authenticate_with_wrong_password
    jessie = users(:jessie)
    
    auth_user = User.authenticate(jessie.email, 'wrong')
    assert !auth_user
  end
  
  
  
end