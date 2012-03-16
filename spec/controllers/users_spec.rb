require 'spec_helper'

describe UsersController do
  it "should render new" do
    get :new
    assigns(:title).should ==  "Sign up"
    response.should render_template 'new'
  end

  it "should create new user" do
    post :create, user: @user
    flash[:success].should == "Welcome to the Todo list!"
    response.should redirect_to @user
  end

  it "should return error if user no created" do
    User.stub!(:new).and_return @user_invalid
    post :create, user: @user
    flash[:error].should == "Error sign up user"
    response.should render_template 'new'
  end

  it "should render edit" do
    get :edit
    assigns(:title).should ==  "Edit user"
    response.should render_template 'edit'
  end

  it "should show project" do
    get :show, id: @user.id
    assigns(:title).should == "Project, task lists of "+@user.name
    response.should render_template 'show'
  end

end