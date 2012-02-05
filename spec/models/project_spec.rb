require 'spec_helper'

describe Project do

  it "should create project with valid attributes" do
    lambda {
      FactoryGirl.create(:project)
    }.should change { Project.count }
  end

  it { should have_many(:task_lists) }

  it { should belong_to(:user) }


end