require 'spec_helper'

describe ProjectsController do

  it "should assigns all projects to @projects_item" do
    get :index
    assigns(:projects_item).should == @project
    response.should render_template(:index)
  end

  it "should show project by id" do
    get :show, id: @project.id
    assigns(:title).should == @project.name
    response.should render_template(:show)
  end

  it "should render new template" do
    get :new
    assigns(:title).should == 'New project'
    response.should render_template(:new)
  end

  it "should render edit template" do
    get :edit, id: @project.id
    assigns(:title).should == 'Edit project '+@project.name
    response.should render_template(:edit)
  end

  it "should create project with valid data" do
    post :create, project: @project
    flash[:success].should == 'Project was successfully created.'
    response.should redirect_to @project
  end

  it "should render new while create project with wrong data" do
    Project.stub!(:new).and_return @project_invalid
    post :create, project: @project
    response.should render_template(:new)
  end

  it "should update project with valid data" do
    post :update, id: @project.id
    flash[:success].should == 'Project was successful updated.'
    response.should redirect_to @project
  end

  it "should render edit until create project with wrong data" do
    Project.stub!(:find).and_return @project_invalid
    post :update, id: @project_invalid.id
    flash[:error].should == 'Project not updated.'
    response.should render_template(:edit)
  end

  it "should redirect if destroyed" do
    get :destroy, id: @project.id
    flash[:success].should == 'Project '+@project.name+' was successfully destroyed.'
    response.should redirect_to projects_path
  end

  it "should render peoples of project list" do
    get :users, id: @project.id
    assigns(:title).should == "Peoples of "+@project.name
    response.should render_template(:users)
  end

  it "should render invite project" do
    get :invite, id: @project.id
    assigns(:title).should == 'Invite to '+@project.name
    response.should render_template(:invite)
  end

  it "should add valid users to project" do
    post :add_user, {id: @project.id, email: @user.email}
    flash[:success].should == 'User was successfully added to project.'
    response.should redirect_to invite_project_url(@project)
  end

  it "should show error if user not found in database" do
    User.stub!(:find_by_email).and_return nil
    post :add_user, {id: @project.id, email: @user.email}
    flash[:error].should == 'No such user.'
    response.should redirect_to invite_project_url(@project)
  end

  it "should show error if relation not saved" do
    User.stub!(:find_by_email).and_return @user
    Relationship.stub!(:new).and_return mock_model(Relationship, save: false)
    post :add_user, {id: @project.id, email: @user.email}
    flash[:error].should == 'Error add user to project.'
    response.should redirect_to invite_project_url(@project)
  end

  it "should remove peoples from project" do
    User.stub!(:find_by_id).and_return @user
    relationship = mock_model(Relationship)
    Relationship.stub!(:where).and_return relationship
    relationship.stub!(:first).and_return relationship
    relationship.stub!(:destroy)
    get :remove_user, {id: @project.id, user_id: @user.id}
    response.should redirect_to users_project_path(@project)
  end

  it "should return redirect_to access_url in authorized method if not signed in" do
    controller.stub!(:current_user).and_return nil
    get :index
    response.should redirect_to access_url
  end

  it "should return redirect to access_url in authorized method if signed but not in project users" do
    @project.stub_chain(:users, :include?).and_return false
    get :index, id: @project.id
    response.should redirect_to access_url
  end

end