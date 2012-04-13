require 'spec_helper'

describe Task do

  it "should create task with valid attributes" do
    lambda {
      FactoryGirl.create(:task)
    }.should change { Task.count }
  end

  it { should belong_to :task_list }

  it { should validate_presence_of(:name)}

  it "should accept valid states" do
    ["done", "not_done", "in_process"].each do |state|
      should allow_value(state).for(:state)
    end
  end

  it "should reject wrong states" do
    ["Don", "Wrong", "Not valid"].each do |state|
      should_not allow_value(state).for(:state)
    end
  end

  it "should have default state not done" do
    task = FactoryGirl.create(:task)
    task.state.should == 'not_done'
  end


  it "should change state" do
    task = FactoryGirl.create(:task)
    ['in_process', 'done', 'not_done'].each do |state|
      task.change_state
      task.state.should == state
    end
  end

end