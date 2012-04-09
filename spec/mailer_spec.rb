require 'spec_helper'
require 'email_spec'

include EmailSpec::Helpers
include EmailSpec::Matchers

describe "Mailer" do

  before(:all) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @task = FactoryGirl.create(:task)
  end

  describe "invite" do

    before(:each) do
      @email = Mailer.invite(@user, @project)
    end

    it "should be set to be delivered to the user email" do
      @email.should deliver_to(@user.email)
    end

    it "should contain the user's message in the subject" do
      @email.should have_subject("You invited to the project #{@project}")
    end

  end

  describe "assignment" do

    before(:each) do
      @email = Mailer.assignment(@user, @project, @task)
    end

    it "should be set to be delivered to the user email" do
      @email.should deliver_to(@user.email)
    end

    it "should contain the user's message in the subject" do
      @email.should have_subject("You have new task #{@task} of project #{@project}")
    end

  end

  describe "changed" do

    before(:each) do
      @email = Mailer.changed(@user, @project, @task)
    end

    it "should be set to be delivered to the user email" do
      @email.should deliver_to(@user.email)
    end

    it "should contain the user's message in the subject" do
      @email.should have_subject("Your task '#{@task}' of '#{@project}' was changed")
    end

  end

end


