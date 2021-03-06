require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username: "Sample User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
    @user.username = "     "
    assert_not @user.valid?
  end

  test "username should have length at least 4 characters long" do
    @user.username = "a" * 3
    assert_not @user.valid?
  end

  test "username should have length no longer than 30 character long" do
    @user.username = "a" * 31
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save

    assert_not duplicate_user.valid?
  end

  test "email should save as lower-case" do
    mixed_case_email = "Foo@EXampLe.coM"
    @user.email = mixed_case_email
    @user.save

    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "email should accept valid email formats" do
    valid_addresses = %w[user@example.com USER@foo.COM
                  A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email should not accept invalid email formats" do
    invalid_addresses = %w[user@example,com user_at_foo.org
                  user.name@example. foo@bar_baz.com foo@bar+baz.com
                  foo@bar..com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?,
      "#{invalid_address.inspect} should be invalid"
    end
  end
end
