require 'spec_helper'

describe User do
  it "should create user with valid attributes" do
    lambda {
      FactoryGirl.create(:user)
    }.should change { User.count }
  end

  it "should have many task_lists, project, relationships, tasks" do
    [:projects, :task_lists, :relationships, :tasks].each do |table|
      should have_many(table)
    end
  end

  it "should have name and email" do
    [:name, :email].each do |field|
      should validate_presence_of(field)
    end
  end

  it "should have maximum length 50 of name" do
    long_name_user = FactoryGirl.build(:user, :name => "n"*51)
    long_name_user.should_not be_valid
  end

  it "should require valid length of password between 6 and 40" do
    short_password_user = FactoryGirl.build(:user, :password=> "p"*5, :password_confirmation => "1"*5)
    short_password_user.should_not be_valid

    long_password_user = FactoryGirl.build(:user, :password => "p"*41, :password_confirmation => "p"*41)
    long_password_user.should_not be_valid
  end

  it "should not accept wrong email" do
    wrong_emails = %w[mail.com mail@mail @mail.com mail@mail. mail@.com]
    wrong_emails.each do |email|
      should_not allow_value(email).for(:email)
    end
  end

  it "should accept valid email" do
    valid_emails = %w[mail@mail.com some@mail.ru mail@gmail.com post@i.ua]
    valid_emails.each do |email|
      should allow_value(email).for(:email)
    end
  end

  it "should not accept two identical emails in different case" do
    attr = FactoryGirl.attributes_for(:user)
    FactoryGirl.create(:user, :email => attr[:email].upcase)
    identical_email_user = FactoryGirl.build(:user, :email => attr[:email].downcase)
    identical_email_user.should_not be_valid
  end

  describe "password encryption" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @attr = FactoryGirl.attributes_for(:user)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end

    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_password_user.should be_nil
    end

    it "should return nil for an email address with no user" do
      nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
      nonexistent_user.should be_nil
    end

    it "should return the user on email/password match" do
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should == @user
    end
  end
end
