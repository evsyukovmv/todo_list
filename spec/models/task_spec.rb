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

  it "should receive mailer for notify about new task" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    task_list = FactoryGirl.create(:task_list, project_id: project.id, user_id: user.id)
    task = FactoryGirl.build(:task, task_list_id: task_list.id, performer_id: user.id)
    Mailer.stub_chain(:assignment, :deliver)
    Mailer.should_receive(:assignment).with(user, project.name, task.name)
    task.save!
  end

  it "should receive mailer for notify about update task" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    task_list = FactoryGirl.create(:task_list, project_id: project.id, user_id: user.id)
    task = FactoryGirl.create(:task, task_list_id: task_list.id, performer_id: user.id)
    Mailer.stub_chain(:changed, :deliver)
    Mailer.should_receive(:changed).with(user, project.name, 'update')
    task.update_attributes(name: 'update')
  end

end