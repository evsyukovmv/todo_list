require 'spec_helper'
require 'cancan/matchers'

describe ProjectsController do

  before(:each) do

    @user = Factory.create(:user)
    sign_in @user

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

    @project_params = { "name" => "Project name", "description" => "description text" }
    @project =  mock_model(Project,  id: 1, name: 'Project name', description: "description text", save: true)

  end

  describe "GET 'index'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      get :index
      response.should redirect_to access_url
    end

    before(:each) do
      @projects_array = [@project, @project, @project]
      controller.stub_chain(:current_user, :projects).and_return @projects_array
      @ability.can :read, Project
    end

    it "should receive projects for current user" do
      controller.stub!(:current_user).and_return @user
      @user.should_receive(:projects).and_return @projects_array
      get :index
    end

    it "should assigns all projects to @projects" do
      get :index
      assigns(:projects).should == @projects_array
    end

    it "should render template index" do
      get :index
      response.should render_template(:index)
    end

  end

  describe "GET 'show' for project" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      get :show, id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      Project.stub!(:find).and_return @project
    end

    it "should receive find and return project" do
      Project.should_receive(:find).with(@project.id.to_s).and_return @project
      get :show, id: @project.id
    end

    it "should assign project" do
      get :show, id: @project.id
      assigns(:project).should == @project
    end

    it "should render template show" do
      get :show, id: @project.id
      response.should render_template(:show)
    end

  end

  describe "GET 'new'" do

    it "should redirect to access page without ability" do
      @ability.cannot :manage, Project
      get :new
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :manage, Project
      Project.stub!(:new).and_return @project
    end

    it "should receive new" do
      Project.should_receive(:new).with({}).and_return @project
      get :new
    end

    it "should assign project" do
      get :new
      assigns(:project).should == @project
    end


    it "should render template new" do
      get :new
      response.should render_template(:new)
    end

  end

  describe "GET 'edit'" do

    it "should redirect to access page without ability" do
      @ability.cannot :manage, Project
      get :edit, id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :manage, Project
      Project.stub!(:find).and_return @project
    end

    it "should receive find and return project" do
      Project.should_receive(:find).with(@project.id.to_s).and_return @project
      get :edit, id: @project.id
    end

    it "should assign project" do
      get :edit, id: @project.id
      assigns(:project).should == @project
    end

    it "should render edit template" do
      get :edit, id: @project.id
      response.should render_template(:edit)
    end

  end

  describe "POST 'create' for project" do

    it "should redirect to access page without ability" do
      @ability.cannot :manage, Project
      post :create, project: @project_params
      response.should redirect_to access_url
    end

    describe "create project with valid data" do

      before(:each) do
        @ability.can :manage, Project
        Project.stub!(:new).and_return @project
      end

      it "should receive new and return project" do
        Project.should_receive(:new).with(@project_params).and_return @project
        post :create, project: @project_params
      end

      it "should assign project" do
        post :create, project: @project_params
        assigns(:project).should == @project
      end

      it "should receive save and return true" do
        @project.should_receive(:save).and_return true
        post :create, project: @project_params
      end

      it "should return success flash" do
        post :create, project: @project_params
        flash[:success].should == 'Project was successfully created'
      end

      it "should redirect to project" do
        post :create, project: @project_params
        response.should redirect_to @project
      end

    end

    describe "create project with invalid data" do

      before(:each) do
        @ability.can :manage, Project
        Project.stub!(:new).and_return @project
        @project.stub!(:save).and_return false
      end

      it "should receive save and return false" do
        @project.should_receive(:save).and_return false
        post :create, project: @project_params
      end

      it "should return error flash" do
        post :create, project: @project_params
        flash[:error].should == 'Project create error'
      end

      it "should render template new" do
        post :create, project: @project_params
        response.should render_template(:new)
      end

    end

  end

  describe "POST 'update' for project" do

    before(:each) do
      Project.stub!(:find).and_return @project
    end

    it "should redirect to access page without ability" do
      @ability.cannot :manage, Project
      post :update, id: @project.id, project: @project_params
      response.should redirect_to access_url
    end

    describe "update project with valid data" do

      before(:each) do
        @project.stub!(:update_attributes).and_return true
        @ability.can :manage, Project
      end

      it "should receive find and return project" do
        Project.should_receive(:find).and_return @project
        post :update, id: @project.id, project: @project_params
      end

      it "should assign project" do
        post :update, id: @project.id, project: @project_params
        assigns(:project).should == @project
      end

      it "should receive update attributes and return true" do
        @project.should_receive(:update_attributes).with(@project_params).and_return true
        post :update, id: @project.id, project: @project_params
      end

      it "should return success flash" do
        post :update, id: @project.id, project: @project_params
        flash[:success].should == 'Project was successful updated'
      end

      it "should redirect to project" do
        post :update, id: @project.id, project: @project_params
        response.should redirect_to @project
      end

    end

    describe "update project with invalid data" do

      before(:each) do
        @project.stub!(:update_attributes).and_return false
        @ability.can :manage, Project
      end

      it "should receive update attributes and return false" do
        @project.should_receive(:update_attributes).and_return false
        post :update, id: @project.id
      end

      it "should return error flash" do
        post :update, id: @project.id
        flash[:error].should == 'Project update error'
      end

      it "should render template edit" do
        post :update, id: @project.id
        response.should render_template(:edit)
      end

    end
  end

  describe "GET 'destroy' for project" do

    before(:each) do
      Project.stub!(:find).and_return @project
    end

    it "should redirect to access page without ability" do
      @ability.cannot :manage, Project
      get :destroy, id: @project.id
      response.should redirect_to access_url
    end

    describe "destroy project with valid data" do

      before(:each) do
        @ability.can :manage, Project
        @project.stub!(:destroy).and_return @project
      end


      it "should receive find and return project" do
        Project.should_receive(:find).with(@project.id.to_s).and_return @project
        get :destroy, id: @project.id
      end

      it "should assign project" do
        get :destroy, id: @project.id
        assigns(:project).should == @project
      end

      it "should receive destroy and return project" do
        @project.should_receive(:destroy).and_return @project
        post :destroy, id: @project.id
      end

      it "should return success flash" do
        get :destroy, id: @project.id
        flash[:success].should == 'Project '+@project.name+' was successfully destroyed'

      end

      it "should redirect to projects_path" do
        get :destroy, id: @project.id
        response.should redirect_to projects_path
      end

    end

    describe "destroy project with invalid data" do

      before(:each) do
        @project.stub!(:destroy).and_return false
        @ability.can :manage, Project
      end

      it "should receive destroy and return false" do
        @project.should_receive(:destroy).and_return false
        post :destroy, id: @project.id
      end

      it "should return error flash" do
        get :destroy, id: @project.id
        flash[:error].should == 'Project destroy error'
      end

      it "should redirect to projects_path" do
        get :destroy, id: @project.id
        response.should redirect_to projects_path
      end

    end

  end

end