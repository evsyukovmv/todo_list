require 'spec_helper'

describe ProjectsController do

  before(:each) do
    @user = mock_model(User, name: 'user name', email: 'email@email.com', password: 'password', save: true)
    controller.stub!(:current_user).and_return @user
    @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)
    @project_invalid =  mock_model(Project,  id: 1, name: 'Project name', save: false)
    @project.stub!(:users).and_return [@user]
  end

  describe "GET 'index'" do

    before(:each) do
      @projects_array= [@project, @project, @project]
      @user.stub!(:projects).and_return @projects_array
      get :index
    end

    it "should assigns all projects to @projects" do
      assigns(:projects).should == @projects_array
    end

    it "should assigns title to All projects" do
      assigns(:title).should == 'All projects'
    end

    it "should render template index" do
      response.should render_template(:index)
    end

  end

  describe "GET 'show' for project" do

    before(:each) do
      Project.stub!(:find).and_return @project
      get :show, id: @project.id
    end

    it "should assigns title to project name" do
      assigns(:title).should == @project.name
    end

    it "should assigns project" do
      assigns(:project).should == @project
    end

    it "should render template show" do
      response.should render_template(:show)
    end

  end

  describe "GET 'new'" do

    before(:each) do
      Project.stub!(:new).and_return @project
      get :new
    end

    it "should assigns title New project" do
      assigns(:title).should == 'New project'
    end

    it "should assigns project" do
      assigns(:project).should == @project
    end

    it "should render template new" do
      response.should render_template(:new)
    end

  end

  describe "GET 'edit'" do

    before(:each) do
      Project.stub!(:find).and_return @project
      get :edit, id: @project.id
    end

    it "should assigns title Edit project name" do
      assigns(:title).should == 'Edit project '+@project.name
    end

    it "should assigns project" do
      assigns(:project).should == @project
    end

    it "should render edit template" do
      response.should render_template(:edit)
    end

  end

  describe "POST 'create' for project" do

    describe "create project with valid data" do

      before(:each) do
        Project.stub!(:new).and_return @project
        @project.stub!(:user_id=)
        post :create, project: @project
      end

      it "should return success flash" do
        flash[:success].should == 'Project was successfully created'
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should redirect to project" do
        response.should redirect_to @project
      end

    end

    describe "create project with invalid data" do

      before(:each) do
        Project.stub!(:new).and_return @project_invalid
        @project_invalid.stub!(:user_id=)
        post :create, project: @project
      end

      it "should assigns invalid project" do
        assigns(:project).should == @project_invalid
      end

      it "should return error flash" do
        flash[:error].should == 'Project create error'
      end

      it "should render template new" do
        response.should render_template(:new)
      end

    end

  end

  describe "POST 'update' for project" do

    describe "update project with valid data" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub!(:update_attributes).and_return @project
        post :update, id: @project.id
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should return success flash" do
        flash[:success].should == 'Project was successful updated'
      end

      it "should redirect to project" do
        response.should redirect_to @project
      end

    end

    describe "update project with invalid data" do
      before(:each) do
        Project.stub!(:find).and_return @project_invalid
        @project_invalid.stub!(:users).and_return [@user]
        @project_invalid.stub!(:update_attributes).and_return false
        post :update, id: @project.id
      end

      it "should assigns invalid project" do
        assigns(:project).should == @project_invalid
      end

      it "should return error flash" do
        flash[:error].should == 'Project update error'
      end

      it "should render template edit" do
        response.should render_template(:edit)
      end

    end
  end

  describe "GET 'destroy' for project" do

    describe "destroy project with valid data" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub!(:destroy).and_return @project
        get :destroy, id: @project.id
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should return success flash" do
        flash[:success].should == 'Project '+@project.name+' was successfully destroyed'
      end

      it "should redirect to projects_path" do
        response.should redirect_to projects_path
      end

    end

    describe "destroy project with invalid data" do

      before(:each) do
        Project.stub!(:find).and_return @project_invalid
        @project_invalid.stub!(:users).and_return [@user]
        @project_invalid.stub!(:destroy).and_return false
        get :destroy, id: @project.id
      end

      it "should assigns invalid project" do
        assigns(:project).should == @project_invalid
      end

      it "should return error flash" do
        flash[:error].should == 'Project destroy error'
      end

      it "should redirect to projects_path" do
        response.should redirect_to projects_path
      end

    end

  end

  describe "GET 'users' for project" do

    before(:each) do
      Project.stub!(:find).and_return @project
      get :users, id: @project.id
    end

    it "should assigns project" do
      assigns(:project).should == @project
    end

    it "should assigns title User of project" do
      assigns(:title).should == "Users of "+@project.name
    end

    it "should render template users" do
      response.should render_template(:users)
    end

  end

  describe "GET 'invite' for project" do

    before(:each) do
      Project.stub!(:find).and_return @project
      get :invite, id: @project.id
    end

    it "should assigns project" do
      assigns(:project).should == @project
    end

    it "should assigns title Invite to project" do
      assigns(:title).should == 'Invite to '+@project.name
    end

    it "should render template invite" do
      response.should render_template(:invite)
    end

  end

  describe "POST 'add_user' for project" do

    describe "add user with valid data" do

      before(:each) do
        User.stub!(:find_by_email).and_return @user
        Project.stub!(:find).and_return @project
        post :add_user, id: @project.id, email: @user.email
      end

      it "should assigns user" do
        assigns(:invited_user).should == @user
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should return flash success" do
        flash[:success].should == 'User was successfully added to project'
      end

      it "should redirect to invite_project_url" do
        response.should redirect_to invite_project_url(@project)
      end
    end

    describe "add user with invalid data" do

      describe "user not found in database" do
        before(:each) do
          Project.stub!(:find).and_return @project
          User.stub!(:find_by_email).and_return nil
          post :add_user, id: @project.id, email: @user.email
        end

        it "should assigns user nil" do
          assigns(:invited_user).should == nil
        end

        it "should assigns project" do
          assigns(:project).should == @project
        end

        it "should return flash error" do
          flash[:error].should == 'Error. No such user'
        end

        it "should redirect to invite_project_url" do
          response.should redirect_to invite_project_url(@project)
        end

      end

    end

    describe "project not found in database" do
      before(:each) do
        User.stub!(:find_by_email).and_return @user
        Project.stub!(:find).and_return nil
        post :add_user, id: @project.id, email: @user.email
      end

      it "should assigns user" do
        assigns(:invited_user).should == @user
      end

      it "should assigns project" do
        assigns(:project).should == nil
      end

      it "should return flash error" do
        flash[:error].should == 'Error. No such project'
      end

      it "should redirect to invite_project_url" do
        response.should redirect_to projects_url
      end

    end

    describe "relation not saved" do
      before(:each) do
        User.stub!(:find_by_email).and_return @user
        Project.stub!(:find).and_return @project
        User.stub!(:find_by_email).and_return @user
        Relationship.stub!(:new).and_return mock_model(Relationship, save: false)
        post :add_user, id: @project.id, email: @user.email
      end

      it "should assigns user" do
        assigns(:invited_user).should == @user
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should return flash error" do
        flash[:error].should == 'Error add user to project'
      end

      it "should redirect to invite_project_url" do
        response.should redirect_to invite_project_url(@project)
      end

    end

  end

  describe "GET 'remove_user' for project" do

    describe "remove with valid data" do

      before(:each) do
        Project.stub!(:find).and_return @project
        User.stub!(:find_by_id).and_return @user
        @user.stub_chain(:relationships, :find_by_project_id, :destroy).and_return @project
        get :remove_user, id: @project.id, user_id: @user.id
      end

      it "should assigns user" do
        assigns(:user).should == @user
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should return flash success" do
        flash[:success].should == 'User '+@user.name+' was successfully removed from project '+@project.name
      end

      it "should redirect to user_project_path" do
        response.should redirect_to users_project_path(@project)
      end

    end

    describe "remove with invalid data" do

      before(:each) do
        Project.stub!(:find).and_return @project
        User.stub!(:find_by_id).and_return @user
        @user.stub_chain(:relationships, :find_by_project_id, :destroy).and_return false
        get :remove_user, id: @project.id, user_id: @user.id
      end

      it "should assigns user" do
        assigns(:user).should == @user
      end

      it "should assigns project" do
        assigns(:project).should == @project
      end

      it "should return flash success" do
        flash[:error].should == 'Error user destroy from project '+@project.name
      end

      it "should redirect to user_project_path" do
        response.should redirect_to users_project_path(@project)
      end

    end

  end

  describe "before filter authorized user" do

    it "should return redirect_to access_url in authorized method if not signed in" do
      controller.stub!(:current_user).and_return nil
      get :index
      response.should redirect_to access_url
    end

    it "should return redirect to access_url in authorized method if signed but not in project users" do
      Project.stub!(:find).and_return @project
      @project.stub_chain(:users, :include?).and_return false
      get :index, id: @project.id
      response.should redirect_to access_url
    end

  end

end