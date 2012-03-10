require 'spec_helper'

describe ProjectsController do
  before(:each) do
    @user = mock_model(User, email: 'email@email.com', save: true)
    @project =  mock_model(Project,  id: 1, name: 'name', save: true)

    @user.stub!(:projects).and_return @project
    @project.stub!(:user_id=)


    controller.stub!(:current_user).and_return @user
    controller.stub!(:authorized_user)

    User.stub!(:find_by_email).and_return @user

    Project.stub!(:find).and_return @project
    Project.stub!(:new).and_return @project
  end

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
    response.should be_redirect
  end

  it "should render new while create project with wrong data" do
    invalid_project = @project
    invalid_project.stub(:save).and_return false
    Project.stub!(:new).and_return invalid_project
    invalid_project.stub!(:user_id=)
    post :create, project: @project
    response.should render_template(:new)
  end

  it "should update project with valid data" do
    @project.stub!(:update_attributes).and_return true
    post :update, id: @project.id
    flash[:success].should == 'Project was successfully updated.'
    response.should be_redirect
  end

  it "should render edit until create project with wrong data" do
    @project.stub!(:update_attributes).and_return false
    post :update, id: @project.id
    response.should render_template(:edit)
  end

  it "should redirect if destroyed" do
    @project.stub!(:destroy)
    get :destroy, id: @project.id
    flash[:success].should == 'Project was successfully destroyed.'
    response.should be_redirect
  end

  it "should render peoples of project list" do
    @project.stub!(:user).and_return 1
    get :peoples, id: @project.id
    assigns(:title).should == "Peoples of "+@project.name
    response.should render_template(:peoples)
  end

  it "should invite valid users to project" do
    post :invite, {id: @project.id, email: @user.email}
    flash[:success].should == 'User was successfully added to project.'
    response.should be_redirect
  end

  it "should show error if invite without email" do
    post :invite, {id: @project.id, email: nil}
    flash[:error].should == 'Expected user and project.'
  end

  it "should show error if user not found in database" do
    User.stub!(:find_by_email).and_return nil
    post :invite, {id: @project.id, email: @user.email}
    flash[:error].should == 'No such user.'
    response.should be_redirect
  end

  it "should show error if relation not saved" do
    User.stub!(:find_by_email).and_return @user
    Relationship.stub!(:new).and_return mock_model(Relationship, save: false)
    post :invite, {id: @project.id, email: @user.email}
    flash[:error].should == 'Error add user to project.'
    response.should be_redirect
  end

  it "should remove peoples from project" do
    User.stub!(:find_by_id).and_return @user
    relationship = mock_model(Relationship)
    Relationship.stub!(:where).and_return relationship
    relationship.stub!(:first).and_return relationship
    relationship.stub!(:destroy)
    get :rempeople, {id: @user.id, project_id: @project.id}
    response.should be_redirect
  end

end