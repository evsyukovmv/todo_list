require 'spec_helper'

describe PagesController do
  it "should show sign up if not signed" do
    controller.stub!(:current_user).and_return nil
    get :home
    assigns(:title).should == "Todo list sign up"
    response.should render_template 'home'
  end

  it "should show home page for sign in user" do
    get :home
    assigns(:title).should == @user.name + " todo list"
    response.should render_template 'home'
  end

  it "should show access page" do
    get :access
    assigns(:title).should == "Access denied"
    response.should render_template 'access'
  end
end