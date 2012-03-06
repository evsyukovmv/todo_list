require 'spec_helper'

describe Task do
  it "should create task with valid attributes" do
    lambda {
      FactoryGirl.create(:task)
    }.should change { Task.count }
  end

  it { should belong_to :task_list }
  it { should belong_to :user }

  it { should validate_presence_of(:name)}

  it "should accept valid states" do
    ["Done", "Not done", "In process"].each do |state|
      should allow_value(state).for(:state)
    end
  end

  it "should reject wrong states" do
    ["Don", "Wrong", "Not valid"].each do |state|
      should_not allow_value(state).for(:state)
    end
  end
end