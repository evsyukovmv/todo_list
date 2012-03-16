require 'spec_helper'

describe TasksController do

  it "should assigns all tasks to @tasks" do
    get :index, task_list_id: @task_list.id
    assigns(:tasks).should == @task
    assigns(:title).should == "All tasks of "+@task_list.name
    response.should render_template(:index)
  end

  it "should filter tasks by state" do
    get :index, task_list_id: @task_list.id, state: 'done'
    assigns(:tasks).should == @task
    assigns(:title).should == "Done tasks of "+@task_list.name


    get :index, task_list_id: @task_list.id, state: 'inprocess'
    assigns(:tasks).should == @task
    assigns(:title).should == "In process tasks of "+@task_list.name


    get :index, task_list_id: @task_list.id, state: 'notdone'
    assigns(:tasks).should == @task
    assigns(:title).should == "Not done tasks of "+@task_list.name

  end

  it "should show task" do
    get :show, task_list_id: @task_list.id, id: @task.id
    assigns(:title).should == @task.name
    assigns(:task).should == @task
    response.should render_template 'show'
  end

  it "should render new task form" do
    get :new, task_list_id: @task_list.id
    assigns(:title).should == "New task in "+@task_list.name
    assigns(:performers).should be_nil
    response.should render_template 'new'
  end


  it "should render new task form in project with invited users" do
    @project.stub!(:users).and_return [@user, @user]
    get :new, task_list_id: @task_list.id
    assigns(:title).should == "New task in "+@task_list.name
    assigns(:performers).should == [@user, @user]
    response.should render_template 'new'
  end

  it "should render edit task form" do
    get :edit, task_list_id: @task_list.id, id: @task.id
    assigns(:title).should == "Edit task "+@task.name+" in "+@task_list.name
    assigns(:performers).should be_nil
    response.should render_template 'edit'
  end


  it "should return edit task form in project with invited users" do
    @project.stub!(:users).and_return [@user, @user]
    get :edit, task_list_id: @task_list.id, id: @task.id
    assigns(:title).should == "Edit task "+@task.name+" in "+@task_list.name
    assigns(:performers).should == [@user, @user]
    response.should render_template 'edit'
  end

  it "should create new task" do
    post :create, task_list_id: @task_list.id, task: @task
    flash[:success].should == 'Task was successfully created'
    response.should redirect_to [@task_list, @task]
  end

  it "should return error when create new task" do
    @task.stub!(:save).and_return false
    post :create, task_list_id: @task_list.id, task: @task
    flash[:error].should == 'Error task create'
    response.should render_template 'new'
  end


  it "should update task" do
    post :update, task_list_id: @task_list.id, id: @task.id
    flash[:success].should == 'Task was successfully updated'
    response.should redirect_to [@task_list, @task]
  end

  it "should return error when update task" do
    @task.stub!(:update_attributes).and_return false
    post :update, task_list_id: @task_list.id, id: @task.id
    flash[:error].should == 'Error task update'
    response.should render_template 'edit'
  end

  it "should destroy task" do
    get :destroy, task_list_id: @task_list.id, id: @task.id
    flash[:success].should == 'Task '+@task.name+' was successfully destroyed'
    response.should redirect_to task_list_tasks_path(@task_list)
  end

  it "should return error if not destroyed" do
    @task_list.stub_chain(:task, :find).and_return @task_invalid
    get :destroy, task_list_id: @task_list, id: @task_invalid.id
    flash[:error].should == 'Error task destroy'
    response.should redirect_to task_list_tasks_path(@task_list)
  end

  it "should change state for task" do
    get :change_state, task_list_id: @task_list, id: @task_invalid.id, state: 'done'
    flash[:success].should == 'Task '+@task.name+' state was successfully updated.'
    response.should redirect_to task_list_tasks_path
  end

  it "should return error if not change state" do
    @task.stub!(:save).and_return false
    get :change_state, task_list_id: @task_list, id: @task_invalid.id, state: 'done'
    flash[:error].should == 'Error change task state'
    response.should redirect_to task_list_tasks_path
  end


  it "should return redirect to access_url in authorized method if signed but not in project users" do
    @project.stub_chain(:users, :include?).and_return false
    @task_list.stub(:user_id).and_return false
    get :index, task_list_id: @task_list.id
    response.should redirect_to access_url
  end

  it "should return redirect to access_url in authorized method if signed but not in task_list user" do
    @task_list.stub(:project).and_return false
    @task_list.stub(:user_id).and_return false
    get :show, task_list_id: @task_list.id, id: @task.id
    response.should redirect_to access_url
  end

end