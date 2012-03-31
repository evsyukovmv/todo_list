require 'spec_helper'

describe TaskListsController do

  before(:each) do
    @user = Factory.create(:user)
    sign_in @user

    @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)
    @task_list =  mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: true)
    @task_list_params = {"name" => "TaskList name"}

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

  end

  describe "GET 'index'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, Project
      @ability.cannot :read, TaskList
      get :index
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :read, TaskList
      @task_lists_array = [@task_list, @task_list, @task_list]
    end

    describe "with project id" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub!(:task_lists).and_return @task_lists_array
      end

      it "should receive task_list for project" do
        @project.should_receive(:task_lists).and_return @task_lists_array
        get :index, project_id: @project.id
      end

      it "should assign all task_list to @task_lists" do
        get :index, project_id: @project.id
        assigns(:task_lists).should == @task_lists_array
      end

      it "should render template index" do
        get :index, project_id: @project.id
        response.should render_template(:index)
      end

    end

    describe "without project" do
      before(:each) do
        Project.stub!(:find).and_return nil
        controller.stub!(:current_user).and_return @user
        controller.stub_chain(:current_user, :task_lists, :where).and_return @task_lists_array
      end

      it "should receive task_lists for current user" do
        @user.task_lists.should_receive(:where).with('project_id IS NULL').and_return @task_lists_array
        get :index, project_id: @project.id
      end

      it "should assign all task_list to @task_lists" do
        get :index, project_id: @project.id
        assigns(:task_lists).should == @task_lists_array
      end

      it "should render template index" do
        get :index, project_id: @project.id
        response.should render_template(:index)
      end

    end

  end

  describe "GET 'show' for task list" do

    it "should redirect to access page without ability" do
      Project.stub!(:find).and_return @project
      @ability.cannot :read, Project
      @ability.cannot :read, TaskList
      get :show, id: @task_list.id, project_id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :read, TaskList
    end

    describe "with project id" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub_chain(:task_lists, :find).and_return @task_list
      end

      it "should receive find" do
        @project.task_lists.should_receive(:find).and_return @task_list
        get :show, id: @task_list.id, project_id: @project.id
      end

      it "should assigns task_list" do
        get :show, id: @task_list.id, project_id: @project.id
        assigns(:task_list).should == @task_list
      end

      it "should render template show" do
        get :show, id: @task_list.id, project_id: @project.id
        response.should render_template(:show)
      end

    end

    describe "without project" do
      before(:each) do
        TaskList.stub!(:find).and_return @task_list
      end

      it "should receive find" do
        TaskList.should_receive(:find).and_return @task_list
        get :show, id: @task_list.id
      end

      it "should assigns task_list" do
        get :show, id: @task_list.id
        assigns(:task_list).should == @task_list
      end

      it "should render template show" do
        get :show, id: @task_list.id
        response.should render_template(:show)
      end

    end

  end

  describe "GET 'new'" do

    it "should redirect to access page without ability" do
      Project.stub!(:find).and_return @project
      @ability.cannot :read, Project
      @ability.cannot :manage, TaskList
      get :new, project_id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, TaskList
    end

    describe "in project" do
      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub_chain(:task_lists, :new).and_return @task_list
      end

      it "should receive new" do
        @project.task_lists.should_receive(:new).with({}).and_return @task_list
        get :new, project_id: @project.id
      end

      it "should assigns task_list" do
        get :new, project_id: @project.id
        assigns(:task_list).should == @task_list
      end

      it "should render template new" do
        get :new, project_id: @project.id
        response.should render_template :new
      end

    end

    describe "without project" do

      before(:each) do
        TaskList.stub!(:new).and_return @task_list
      end

      it "should receive new" do
        TaskList.should_receive(:new).with({}).and_return @task_list
        get :new
      end

      it "should assigns task_list" do
        get :new
        assigns(:task_list).should == @task_list
      end

      it "should render template new" do
        get :new
        response.should render_template :new
      end

    end

  end


  describe "POST 'create'" do

    it "should redirect to access page without ability" do
      Project.stub!(:find).and_return @project
      @ability.cannot :read, Project
      @ability.cannot :manage, TaskList
      post :create, project_id: @project.id, task_list: @task_list_params
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, TaskList
    end

    describe "with project" do

      describe "with valid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :new).and_return @task_list
          @task_list.stub!(:save).and_return true
        end

        it "should receive new" do
          @project.task_lists.should_receive(:new).and_return @task_list
          post :create, project_id: @project.id, task_list: @task_list_params
        end

        it "should assigns task_list" do
          post :create, project_id: @project.id, task_list: @task_list_params
          assigns(:task_list).should == @task_list
        end

        it "should receive save" do
          @task_list.should_receive(:save).and_return @task_list
          post :create, project_id: @project.id, task_list: @task_list_params
        end

        it "should have flash success" do
          post :create, project_id: @project.id, task_list: @task_list_params
          flash[:success].should == "Task list was successful created"
        end

        it "should redirect to project task lists path" do
          post :create, project_id: @project.id, task_list: @task_list_params
          response.should redirect_to project_task_lists_path(@project)
        end

      end


      describe "with invalid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :new).and_return @task_list
          @task_list.stub!(:save).and_return false
          post :create, project_id: @project.id, task_list: @task_list_invalid
        end

        it "should have flash success" do
          flash[:error].should == "Error task list create"
        end

        it "should redirect to project task lists path" do
          response.should render_template :new
        end

      end

    end

    describe "without project" do

      describe "with valid data" do

        before(:each) do
          TaskList.stub!(:new).and_return @task_list
          TaskList.stub!(:save).and_return true
        end

        it "should receive new" do
          TaskList.should_receive(:new).and_return @task_list
          post :create, task_list: @task_list_params
        end


        it "should assigns task_list" do
          post :create, task_list: @task_list_params
          assigns(:task_list).should == @task_list
        end

        it "should receive save" do
          @task_list.should_receive(:save).and_return @task_list
          post :create, task_list: @task_list_params
        end

        it "should have flash success" do
          post :create, task_list: @task_list_params
          flash[:success].should == "Task list was successful created"
        end

        it "should redirect to project task lists path" do
          post :create, task_list: @task_list_params
          response.should redirect_to task_lists_path
        end

      end


      describe "with invalid data" do

        before(:each) do
          TaskList.stub!(:new).and_return @task_list
          @task_list.stub!(:save).and_return false
          post :create, task_list: @task_list_params
        end

        it "should have flash success" do
          flash[:error].should == "Error task list create"
        end

        it "should redirect to project task lists path" do
          response.should render_template :new
        end

      end

    end

  end

  describe "GET 'edit'" do

    it "should redirect to access page without ability" do
      Project.stub!(:find).and_return @project
      @ability.cannot :read, Project
      @ability.cannot :manage, TaskList
      get :edit, id: @task_list.id, project_id: @project.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, TaskList
    end

    describe "with project" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub_chain(:task_lists, :find).and_return @task_list
      end

      it "should receive find" do
        @project.task_lists.should_receive(:find).and_return @task_list
        get :edit, id: @task_list.id, project_id: @project.id
      end


      it "should assign task list" do
        get :edit, id: @task_list.id, project_id: @project.id
        assigns(:task_list).should == @task_list
      end

      it "should render template 'edit'" do
        get :edit, id: @task_list.id, project_id: @project.id
        response.should render_template :edit
      end

    end

    describe "without project" do

      before(:each) do
        TaskList.stub!(:find).and_return @task_list
      end

      it "should receive find" do
        TaskList.should_receive(:find).and_return @task_list
        get :edit, id: @task_list.id
      end

      it "should assign task list" do
        get :edit, id: @task_list.id
        assigns(:task_list).should == @task_list
      end

      it "should render template 'edit'" do
        get :edit, id: @task_list.id
        response.should render_template :edit
      end

    end

  end

  describe "POST 'update'" do


    it "should redirect to access page without ability" do
      Project.stub!(:find).and_return @project
      @ability.cannot :read, Project
      @ability.cannot :manage, TaskList
      post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, TaskList
    end

    describe "with project" do

      describe "with valid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:update_attributes).and_return true
        end

        it "should receive find" do
          @project.task_lists.should_receive(:find).and_return @task_list
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
        end

        it "should assigns task list" do
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
          assigns(:task_list).should == @task_list
        end

        it "should receive update" do
          @task_list.should_receive(:update_attributes).and_return true
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
        end

        it "should have flash success" do
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
          flash[:success].should == "Task list was successful updated"
        end

        it "should redirect to project task lists path" do
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
          response.should redirect_to([@project, @task_list])
        end

      end


      describe "with invalid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:update_attributes).and_return false
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_params
        end

        it "should have flash error" do
          flash[:error].should == "Error task list update"
        end

        it "should redirect to project task lists path" do
          response.should render_template :edit
        end

      end

    end

    describe "without project" do

      describe "with valid data" do

        before(:each) do
          TaskList.stub!(:find).and_return @task_list
          @task_list.stub!(:update_attributes).and_return true
          post :update, id: @task_list.id, task_list: @task_list
        end

        it "should have flash success" do
          flash[:success].should == "Task list was successful updated"
        end

        it "should redirect to project task lists path" do
          response.should redirect_to(@task_list)
        end

      end


      describe "with invalid data" do

        before(:each) do
          TaskList.stub!(:find).and_return @task_list
          @task_list.stub!(:update_attributes).and_return false
          post :update, id: @task_list.id, task_list: @task_list
        end

        it "should have flash error" do
          flash[:error].should == "Error task list update"
        end

        it "should redirect to project task lists path" do
          response.should render_template :edit
        end

      end

    end

  end

  describe "GET 'destroy'" do

    it "should redirect to access page without ability" do
      Project.stub!(:find).and_return @project
      @ability.cannot :read, Project
      @ability.cannot :manage, TaskList
      get :destroy, project_id: @project.id, id: @task_list.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, Project
      @ability.can :manage, TaskList
    end

    describe "with project" do

      describe "with valid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:destroy).and_return @task_list
        end

        it "should receive find" do
          @project.task_lists.should_receive(:find).and_return @task_list
          get :destroy, project_id: @project.id, id: @task_list.id
        end

        it "should assigns task list" do
          get :destroy, project_id: @project.id, id: @task_list.id
          assigns(:task_list).should == @task_list
        end

        it "should receive destroy" do
          @task_list.should_receive(:destroy).and_return @task_list
          get :destroy, project_id: @project.id, id: @task_list.id
        end

        it "should have flash success" do
          get :destroy, project_id: @project.id, id: @task_list.id
          flash[:success].should == 'Task list '+@task_list.name+' was successfully destroyed'
        end

        it "should redirect to project task lists path" do
          get :destroy, project_id: @project.id, id: @task_list.id
          response.should redirect_to project_task_lists_path(@project)
        end

      end

      describe "with invalid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:destroy).and_return false
        end

        it "should have flash error" do
          get :destroy, project_id: @project.id, id: @task_list.id
          flash[:error].should == 'Error task list destroy'
        end

        it "should redirect to project task lists path" do
          get :destroy, project_id: @project.id, id: @task_list.id
          response.should redirect_to project_task_lists_path(@project)
        end

      end
    end


    describe "without project" do

      describe "with valid data" do

        before(:each) do
          TaskList.stub!(:find).and_return @task_list
          @task_list.stub!(:destroy).and_return @task_list
        end

        it "should have flash success" do
          get :destroy, id: @task_list.id
          flash[:success].should == 'Task list '+@task_list.name+' was successfully destroyed'
        end

        it "should redirect to project task lists path" do
          get :destroy, id: @task_list.id
          response.should redirect_to task_lists_path
        end

      end

      describe "with invalid data" do

        before(:each) do
          TaskList.stub!(:find).and_return @task_list
          @task_list.stub!(:destroy).and_return false
        end

        it "should have flash error" do
          get :destroy, id: @task_list.id
          flash[:error].should == 'Error task list destroy'
        end

        it "should redirect to project task lists path" do
          get :destroy, id: @task_list.id
          response.should redirect_to task_lists_path
        end

      end

    end

  end

end