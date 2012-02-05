require 'spec_helper'

describe TaskList do
  it "should create task_list with valid attributes" do
    lambda {
      FactoryGirl.create(:task_list)
    }.should change { TaskList.count }
  end

  it { should have_many :task}
  it { should belong_to :user }
  it { should belong_to :project }
end