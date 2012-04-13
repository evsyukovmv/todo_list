require 'spec_helper'

describe User do
  it "should create task with valid attributes" do
    lambda {
      FactoryGirl.create(:user)
    }.should change { User.count }
  end

  it { should have_many :task_lists }
  it { should have_many :projects }

end