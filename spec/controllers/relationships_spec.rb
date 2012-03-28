require 'spec_helper'
require 'cancan/matchers'

describe RelationshipsController do

  before(:each) do

    @user = Factory.create(:user)
    sign_in @user

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

    @project =  mock_model(Project,  id: 1, name: 'Project name', description: "description text", save: true)
    Project.stub!(:find).and_return @project

    @relationship = mock_model(Relationship, id: 1, project_id: @project.id, user_id: @user.id, save: true)
    @relationship_array = [@relationship, @relationship, @relationship]

  end

  describe "GET 'index'" do
    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      @ability.cannot :read, Relationship
      get :index, project_id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :read, Relationship
      @project.stub!(:relationships).and_return @relationship_array
    end

    it "should receive relationships for project" do
      @project.should_receive(:relationships).and_return @relationship_array
      get :index, project_id: @project.id
    end

    it "should assign all relationships of project to @relationships" do
      get :index, project_id: @project.id
      assigns(:relationships).should == @relationship_array
    end

    it "should render template index" do
      get :index, project_id: @project.id
      response.should render_template(:index)
    end

  end

  describe "GET 'new'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      @ability.cannot :manage, Relationship
      get :new, project_id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, Relationship
      @project.stub_chain(:relationships, :new).and_return @relationship
    end

    it "should receive new" do
      @project.relationships.should_receive(:new).with({}).and_return @relationship
      get :new, project_id: @project.id
    end

    it "should assign relationship" do
      get :new, project_id: @project.id
      assigns(:relationship).should == @relationship
    end

    it "should render template new" do
      get :new, project_id: @project.id
      response.should render_template :new
    end

  end

  describe "POST 'create'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      @ability.cannot :manage, Relationship
      post :create, project_id: @project.id, email: @user.email
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, Relationship
    end

    describe "with valid data" do

      before(:each) do
        User.stub!(:find_by_email).and_return @user
        @project.stub_chain(:relationships, :new).and_return @relationship
        @relationship.stub!(:user_id=)
        @relationship.stub!(:save).and_return true
      end

      it "should assigns invited user" do
        post :create, project_id: @project.id, email: @user.email
        assigns(:invited_user).should == @user
      end

      it "should assign relationship" do
        post :create, project_id: @project.id, email: @user.email
        assigns(:relationship).should == @relationship
      end

      it "should receive save and return true" do
        @relationship.should_receive(:save).and_return true
        post :create, project_id: @project.id, email: @user.email
      end

      it "should return flash success" do
        post :create, project_id: @project.id, email: @user.email
        flash[:success].should == 'User was successfully added to project'
      end

      it "should redirect to new_project_user_path" do
        post :create, project_id: @project.id, params: {"email" => @user.email}
        response.should redirect_to new_project_user_path(@project)
      end

    end

    describe "with invalid user" do

      before(:each) do
        User.stub!(:find_by_email).and_return nil
        @project.stub_chain(:relationships, :new).and_return @relationship
      end

      it "should assigns invited user to nil" do
        post :create, project_id: @project.id, email: @user.email
        assigns(:invited_user).should == nil
      end

      it "should not receive save" do
        @relationship.should_not_receive(:save)
        post :create, project_id: @project.id, email: @user.email
      end

      it "should return flash error" do
        post :create, project_id: @project.id, email: @user.email
        flash[:error].should == 'Error. No such user'
      end

      it "should redirect to new_project_user_path" do
        post :create, project_id: @project.id, params: {"email" => @user.email}
        response.should redirect_to new_project_user_path(@project)
      end

    end

    describe "relationship not saved" do

      before(:each) do
        User.stub!(:find_by_email).and_return @user
        @project.stub_chain(:relationships, :new).and_return @relationship
        @relationship.stub!(:user_id=)
        @relationship.stub!(:save).and_return false
      end

      it "should receive save and return false" do
        @relationship.should_receive(:save).and_return false
        post :create, project_id: @project.id, email: @user.email
      end

      it "should return flash error" do
        post :create, project_id: @project.id, email: @user.email
        flash[:error].should == 'Error add user to project'
      end

      it "should redirect to new_project_user_path" do
        post :create, project_id: @project.id, params: {"email" => @user.email}
        response.should redirect_to new_project_user_path(@project)
      end

    end

  end

  describe "GET 'destroy'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      @ability.cannot :manage, Relationship
      get :destroy, project_id: @project.id, id: @relationship.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, Relationship
    end

    describe "with valid data" do

      before(:each) do
        @project.stub_chain(:relationships, :find).and_return @relationship
        @relationship.stub!(:destroy).and_return @relationship
      end

      it "should receive find and return relationship" do
        @project.relationships.should_receive(:find).and_return @relationship
        get :destroy, project_id: @project.id, id: @relationship.id
      end

      it "should assign relationship" do
        get :destroy, project_id: @project.id, id: @relationship.id
        assigns(:relationship).should == @relationship
      end

      it "should receive destroy" do
        @relationship.should_receive(:destroy).and_return @relationship
        get :destroy, project_id: @project.id, id: @relationship.id
      end

      it "should return flash success" do
        get :destroy, project_id: @project.id, id: @relationship.id
        flash[:success].should  == 'User was successfully removed from project '+@project.name
      end

      it "should redirect to project users path" do
        get :destroy, project_id: @project.id, id: @relationship.id
        response.should redirect_to project_users_path(@project)
      end

    end

    describe "with invalid data" do

      before(:each) do
        @project.stub_chain(:relationships, :find).and_return @relationship
        @relationship.stub!(:destroy).and_return false
      end

      it "should receive find and return relationship" do
        @project.relationships.should_receive(:find).and_return @relationship
        get :destroy, project_id: @project.id, id: @relationship.id
      end

      it "should return flash error" do
        get :destroy, project_id: @project.id, id: @relationship.id
        flash[:error].should  == 'Error user destroy from project '+@project.name
      end

      it "should redirect to project users path" do
        get :destroy, project_id: @project.id, id: @relationship.id
        response.should redirect_to project_users_path(@project)
      end

    end

  end

end