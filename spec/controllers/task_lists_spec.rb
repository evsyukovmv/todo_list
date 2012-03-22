require 'spec_helper'

describe TaskListsController do

  before(:each) do
    @user = Factory.create(:user)
    sign_in @user

    @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)
    @task_list =  mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: true)
    @task_list_invalid = mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: false, destroy: false)

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

    @ability.can :manage, Project
    @ability.can :manage, TaskList
  end

  describe "GET 'index'" do

    before(:each) do
      @task_lists_array = [@task_list, @task_list, @task_list]
    end

    describe "with project id" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub!(:task_lists).and_return @task_lists_array
        get :index, project_id: @project.id
      end

      it "should assign all task_list to @task_lists" do
        assigns(:task_lists).should == @task_lists_array
      end

      it "should assigns title 'All task lists of project'" do
        assigns(:title).should == 'All task lists of project '+@project.name
      end

      it "should render template index" do
        response.should render_template(:index)
      end

    end

    describe "without project" do
      before(:each) do
        Project.stub!(:find).and_return nil
        controller.stub_chain(:current_user, :task_lists, :where).and_return @task_lists_array
        get :index, project_id: @project.id
      end

      it "should assign all task_list to @task_lists" do
        assigns(:task_lists).should == @task_lists_array
      end

      it "should assigns title 'All task lists'" do
        assigns(:title).should == 'All task lists'
      end

      it "should render template index" do
        response.should render_template(:index)
      end

    end

  end

  describe "GET 'show' for task list" do

    describe "with project id" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub!(:task_lists).and_return @task_list
        #TaskList.stub!(:find).and_return @task_list
        get :index, project_id: @project.id
      end

      it "should assigns task_list" do
        assigns(:task_list).should == @task_list
      end

      it "should assigns title to project name" do
        assigns(:title).should == @task_list.name+' of '+@project.name
      end

      it "should render template show" do
        response.should render_template(:show)
      end

    end

  end

=begin

  it "should show task_list in project" do
    get :show, id: @task_list.id, project_id: @project.id
    assigns(:title).should == @task_list.name + ' of '+@project.name
    response.should render_template(:show)
  end

  it "should show task_list" do
    get :show, id: @task_list.id
    assigns(:title).should == @task_list.name
    response.should render_template(:show)
  end

  it "should show new form in project" do
    get :new, project_id: @project.id
    assigns(:title).should ==  "New task list in project "+@project.name
    response.should render_template(:new)
  end

  it "should show new form" do
    get :new
    assigns(:title).should ==  "New task list"
    response.should render_template(:new)
  end

  it "should show edit form with task list in project" do
    get :edit, id: @task_list.id, project_id: @project.id
    assigns(:title).should == "Edit "+@task_list.name+" in "+@project.name
    response.should render_template(:edit)
  end

  it "should show edit form with task list" do
    get :edit, id: @task_list.id
    assigns(:title).should == "Edit "+@task_list.name
    response.should render_template(:edit)
  end

  it "should create task list in project" do
    post :create, project_id: @project.id, task_list: @task_list
    flash[:success].should == 'Task list was successful created.'
    response.should redirect_to  redirect_to(project_task_lists_path(@project))
  end

  it "should create task list" do
    post :create, task_list: @task_list
    flash[:success].should == 'Task list was successful created.'
    response.should redirect_to  redirect_to(task_lists_path)
  end

  it "should create task list in project" do
    post :create, project_id: @project.id, task_list: @task_list
    flash[:success].should == 'Task list was successful created.'
    response.should redirect_to(project_task_lists_path(@project))
  end

  it "should show error if task list not created" do
    controller.stub_chain(:current_user, :task_lists, :new).and_return @task_list_invalid
    post :create, task_list: @task_list_invalid
    flash[:error].should == 'Error task list create!'
    response.should render_template(:new)
  end

  it "should update task list in project" do
    post :update, project_id: @project.id, id: @task_list.id
    flash[:success].should == 'Task list was successful updated.'
    response.should redirect_to  [@project, @task_list]
  end

  it "should update task list" do
    post :update, id: @task_list.id
    flash[:success].should == 'Task list was successful updated.'
    response.should redirect_to  @task_list
  end

  it "should show error if not updated task list" do
    TaskList.stub!(:find).and_return @task_list_invalid
    post :update, id: @task_list_invalid.id
    flash[:error].should == 'Error task list update.'
    response.should render_template 'edit'
  end

  it "should destroy task list" do
    get :destroy, id: @task_list.id
    flash[:success].should == 'Task list '+@task_list.name+' was successfully destroyed.'
    response.should redirect_to task_lists_path
  end

  it "should destroy task list in project" do
    get :destroy, project_id: @project.id, id: @task_list.id
    flash[:success].should == 'Task list '+@task_list.name+' was successfully destroyed.'
    response.should redirect_to project_task_lists_path(@project)
  end

  it "should show error if not destroyed" do
    TaskList.stub!(:find).and_return @task_list_invalid
    get :destroy, id: @task_list_invalid.id
    flash[:error].should == 'Error task list destroy'
    response.should redirect_to task_lists_path
  end

  it "should return redirect_to access_url in authorized method if not signed in" do
    Project.stub!(:find).and_return nil
    TaskList.stub!(:find).and_return nil
    controller.stub!(:current_user).and_return nil
    get :index
    response.should redirect_to access_url
  end

  it "should return redirect to access_url in authorized method if signed but not in project users" do
    @project.stub_chain(:users, :include?).and_return false
    get :index, project_id: @project.id
    response.should redirect_to access_url
  end

  it "should return redirect to access_url in authorized method if signed but not in task_list user" do
    @task_list.stub!(:user_id).and_return false
    get :show, id: @task_list.id
    response.should redirect_to access_url
  end
=end

end