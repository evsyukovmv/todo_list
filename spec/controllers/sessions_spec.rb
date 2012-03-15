require 'spec_helper'

describe SessionsController do

  it "should create current_user with valid data" do
    User.stub!(:authenticate).and_return @user
    post :create, :session => {email: @user.email, password: @user.password}
    assigns(:current_user).should == @user
  end

  it "should put error with invalid data" do
    User.stub!(:authenticate).and_return nil
    post :create, :session => {email: @user.email, password: @user.password}
    flash.now[:error].should == 'Invalid email/password combination.'
    response.should render_template(:new)
  end

  it "should destroy current_user" do
    User.stub!(:authenticate).and_return @user
    post :create, :session => {email: @user.email, password: @user.password}
    get :destroy
    assigns(:current_user).should == nil
  end

end