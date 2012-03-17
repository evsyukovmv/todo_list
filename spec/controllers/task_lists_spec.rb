require 'spec_helper'

describe TaskListsController do
  it "should assigns all task_lists in project" do
    get :index, project_id: @project.id
    assigns(:task_lists).should == @task_lists_array
    assigns(:title).should == 'All task lists of project '+@project.name
    response.should render_template(:index)
  end

  it "should assigns all task_lists project" do
    get :index
    assigns(:task_lists).should == @task_lists_array
    assigns(:title).should == 'All task lists'
    response.should render_template(:index)
  end

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

end