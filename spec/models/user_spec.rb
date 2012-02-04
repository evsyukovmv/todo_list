require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    }
  end

  it "should create user with valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should have maximum length 50 of name" do
    long_name_user = User.new(@attr.merge(:name => "n"*51))
    long_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should require a password" do
    no_password_user = User.new(@attr.merge(:password => ""))
    no_password_user.should_not be_valid
  end

  it "should require valid length of password between 6 and 40" do
    short_password_user = User.new(@attr.merge(:password=> "p"*5, :password_confirmation => "1"*5))
    short_password_user.should_not be_valid

    long_password_user = User.new(@attr.merge(:password => "p"*41, :password_confirmation => "p"*41))
    long_password_user.should_not be_valid
  end

  it "should require a password_confirmation" do
    no_password_confirmation_user = User.new(@attr.merge(:password_confirmation=> "wrong_password"))
    no_password_confirmation_user.should_not be_valid
  end

  it "should not accept wrong email" do
    wrong_emails = %w[mail.com mail@mail @mail.com mail@mail. mail@.com]
    wrong_emails.each do |email|
      wrong_email_user = User.new(@attr.merge(:email => email))
      wrong_email_user.should_not be_valid
    end
  end

  it "should accept valid email" do
    valid_emails = %w[mail@mail.com some@mail.ru mail@gmail.com post@i.ua]
    valid_emails.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should be_valid
    end
  end

  it "should not accept two identical emails in different case" do
    User.create(@attr.merge(:email => :email.upcase))
    identical_email_user = User.new(@attr.merge(:email => :email.downcase))
    identical_email_user.should_not be_valid
  end

end
