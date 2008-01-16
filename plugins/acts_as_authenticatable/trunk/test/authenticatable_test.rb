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
    
    assert !user.verified?
    
    new_user = User.authenticate("hans_wurst@hund.com", "dolles_password")
    assert_nil new_user
    
    u = User.verify(user.email, user.security_token)
    assert u.verified?
    assert u.valid?
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
    assert users(:jessie).valid?
  end
  
  def test_should_authenticate_with_something_else_and_password
    krystal = Account.authenticate(accounts(:krystal).account_number, 'alongtest')
    assert_not_nil krystal
    assert_kind_of(Account, krystal)
    assert_equal accounts(:krystal), krystal
    assert accounts(:krystal).valid?
  end
  
  def test_not_authenticate_with_wrong_password
    jessie = users(:jessie)
    
    auth_user = User.authenticate(jessie.email, 'wrong')
    assert !auth_user
  end
  
  def test_should_ignore_presence_of_security_token_and_token_expiry_if_user_is_verified
    assert users(:verified_user_without_token).valid?
    
    assert !users(:not_verified_user_without_token).valid?
  end
  
  def test_should_change_password
    jessie = users(:jessie)
    old_password = jessie.salted_password
    jessie.change_password("fnurb","fnurb")
    jessie.save
    jessie.reload
    assert_not_equal old_password, jessie.salted_password
    assert_equal User.hashed("fnurb", users(:jessie).salt), jessie.salted_password
  end
  
  def test_should_not_change_password_if_password_is_to_short
    jessie = users(:jessie)
    old_password = jessie.salted_password
    jessie.change_password("f","f")
    jessie.save
    jessie.reload
    assert_equal old_password, jessie.salted_password
  end

  def test_should_not_change_password_if_confirm_is_incorrect
    jessie = users(:jessie)
    old_password = jessie.salted_password
    jessie.change_password("fnurb","fnurb_wrong")
    jessie.save
    jessie.reload
    assert_equal old_password, jessie.salted_password
  end
  
  def test_should_set_new_security_token_and_expiry_upon_email_change
    user = users(:john)
    old_security_token = user.security_token

    user.try_change_email("new_john_doe@somethingelse.com", "new_john_doe@somethingelse.com")
    assert user.valid?, user.errors.full_messages
    assert_not_nil user.security_token
    assert_not_equal old_security_token, user.security_token
    assert_not_nil user.token_expiry
    assert_equal (Time.now + 1.day).to_date, user.token_expiry
  end

  def test_should_not_change_email_by_invalid_email
    user = users(:john)
    
    user.try_change_email("new_john_doesomethingelse.com", "new_john_doesomethingelse.com")
    email = user.email
    new_email = user.new_email    
    assert_not_equal new_email, user.email
    assert !user.valid?
  end
    
  def test_should_not_set_new_security_token_if_incorrect_confirm
    user = users(:john)
    old_security_token = user.security_token

    user.try_change_email("new_john_doe@somethingelse.com", "wrong@dingadong.com")
    assert user.valid?, user.errors.full_messages
    assert_not_nil user.security_token
    assert_equal old_security_token, user.security_token
  end
  
  def test_should_set_new_email_if_verified_by_tokenand_new_email_is_not_empty
    user = users(:verified_user_with_new_email)
    
    assert user.email
    old_email = user.email
    assert user.new_email
    new_email = user.new_email
    assert user.security_token
    
    user.verify_by_token(user.security_token)
    assert user.new_email.blank?
    assert new_email, user.email
    
    user.verify_by_token(user.security_token)
    assert user.email
    assert user.email.length > 0
    assert new_email, user.email
  end
  
  def test_should_verify_user_by_token
    user = users(:not_verified_user_with_token)
    assert !user.verified?
    
    user.verify_by_token(user.security_token)
    assert user.verified?
  end
  
  def test_should_not_verify_user_with_expired_token
    user = users(:not_verified_user_with_expired_token)
    assert !user.verified?
    assert user.token_expiry < Time.now.to_date
    
    user.verify_by_token(user.security_token)
    assert !user.verified?
  end
  
end