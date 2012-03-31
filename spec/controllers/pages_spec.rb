require 'spec_helper'

describe PagesController do

  before(:each) do
    @user = Factory.create(:user)
  end

  describe "user not signed in" do

    it "should receive new for user" do
      User.should_receive(:new)
      get :home
    end

    it "should be user" do
      get :home
      assigns(:user).should be_new_record
    end

    it "should render template home" do
      get :home
      response.should render_template 'home'
    end

  end

  describe "user signed in" do

    before(:each) do
      sign_in @user
      controller.stub!(:current_user).and_return @user

      @project = mock_model(Project)
      @projects_array = [@project, @project, @project]
      controller.stub_chain(:current_user, :projects).and_return @projects_array

      @task_list = mock_model(TaskList)
      @task_lists_array = [@task_list, @task_list, @task_list]
      controller.stub_chain(:current_user, :task_lists, :where).and_return @task_lists_array
    end

    it "should receive projects for current_user" do
      @user.should_receive(:projects).and_return @projects_array
      get :home
    end

    it "should have projects" do
      get :home
      assigns(:projects).should == @projects_array
    end

    it "should receive task_lists for current_user" do
      @user.task_lists.should_receive(:where).with("project_id IS NULL")
      get :home
    end

    it "should have task_lists" do
      get :home
      assigns(:task_lists).should == @task_lists_array
    end

    it "should render template home" do
      get :home
      response.should render_template 'home'
    end

  end

  it "should show access page" do
    get :access
    response.should render_template 'access'
  end
end