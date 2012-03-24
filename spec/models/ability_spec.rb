require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  before(:each) do
    @user_owner = User.create!(email: 'owner@mail.com', password: 'password', password_confirmation: 'password')
    @user_invited = User.create!(email: 'invited@mail.com', password: 'password', password_confirmation: 'password')
    @user_other = User.create!(email: 'other@mail.com', password: 'password', password_confirmation: 'password')
    @ability_owner = Ability.new(@user_owner)
    @ability_invited = Ability.new(@user_invited)
    @ability_other= Ability.new(@user_other)

    @project = Project.create!(name: 'project name', user_id: @user_owner.id)
    Relationship.create!(project_id: @project.id, user_id: @user_invited.id)
  end

  describe "Project" do

    it "should owner have ability for manage" do
      @ability_owner.should be_able_to(:manage, @project)
    end

    it "should invited have not ability for manage" do
      @ability_invited.should_not be_able_to(:manage, @project)
    end

    it "should invited have ability for read" do
      @ability_invited.should be_able_to(:read, @project)
    end

    it "should other have not ability for manage" do
      @ability_other.should_not be_able_to(:manage, @project)
    end

    it "should other have not ability for read" do
      @ability_other.should_not be_able_to(:read, @project)
    end

  end

  describe "Task list" do

    before(:each) do
      @task_list = TaskList.create!(name: 'task list name', project_id: @project.id)
    end

    it "should owner have ability for manage" do
      @ability_owner.should be_able_to(:manage, @task_list)
    end

    it "should invited have ability for manage" do
      @ability_invited.should be_able_to(:manage, @task_list)
    end

    it "should other have not ability for manage" do
      @ability_other.should_not be_able_to(:manage, @task_list)
    end

    it "should other have not ability for read" do
      @ability_other.should_not be_able_to(:read, @task_list)
    end


  end

  describe "Task" do

    before(:each) do
      @task_list = TaskList.create!(name: 'task list name', project_id: @project.id)
      @task = Task.create!(name: 'task name', state: 'done', priority: '1', task_list_id: @task_list.id)
    end

    it "should owner have ability for manage" do
      @ability_owner.should be_able_to(:manage, @task)
    end

    it "should invited have ability for manage" do
      @ability_invited.should be_able_to(:manage, @task)
    end

    it "should other have not ability for manage" do
      @ability_other.should_not be_able_to(:manage, @task)
    end

    it "should other have not ability for read" do
      @ability_other.should_not be_able_to(:read, @task)
    end


  end



end