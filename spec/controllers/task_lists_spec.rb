require 'spec_helper'

describe TaskListsController do

  before(:each) do
    @user = Factory.create(:user)
    sign_in @user

    @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)
    @task_list =  mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: true)
    @task_list_invalid = mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: false, destroy: false)

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

    @ability.can :manage, Project
    @ability.can :manage, TaskList
  end

  describe "GET 'index'" do

    before(:each) do
      @task_lists_array = [@task_list, @task_list, @task_list]
    end

    describe "with project id" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub!(:task_lists).and_return @task_lists_array
        get :index, project_id: @project.id
      end

      it "should assign all task_list to @task_lists" do
        assigns(:task_lists).should == @task_lists_array
      end

      it "should assigns title 'All task lists of project'" do
        assigns(:title).should == "All task lists of project "+@project.name
      end

      it "should render template index" do
        response.should render_template(:index)
      end

    end

    describe "without project" do
      before(:each) do
        Project.stub!(:find).and_return nil
        controller.stub_chain(:current_user, :task_lists, :where).and_return @task_lists_array
        get :index, project_id: @project.id
      end

      it "should assign all task_list to @task_lists" do
        assigns(:task_lists).should == @task_lists_array
      end

      it "should assigns title 'All task lists'" do
        assigns(:title).should == 'All task lists'
      end

      it "should render template index" do
        response.should render_template(:index)
      end

    end

  end

  describe "GET 'show' for task list" do

    describe "with project id" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub_chain(:task_lists, :find).and_return @task_list
        get :show, id: @task_list.id, project_id: @project.id
      end

      it "should assigns task_list" do
        assigns(:task_list).should == @task_list
      end

      it "should assigns title task list of project" do
        assigns(:title).should == @task_list.name+' of '+@project.name
      end

      it "should render template show" do
        response.should render_template(:show)
      end

    end

    describe "without project" do
      before(:each) do
        TaskList.stub!(:find).and_return @task_list
        get :show, id: @task_list.id
      end

      it "should assigns task_list" do
        assigns(:task_list).should == @task_list
      end

      it "should assigns title task list" do
        assigns(:title).should == @task_list.name
      end

      it "should render template show" do
        response.should render_template(:show)
      end

    end

  end

  describe "GET 'new'" do

    describe "in project" do
      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub_chain(:task_lists, :new).and_return @task_list
        get :new, project_id: @project.id
      end

      it "should assigns title new in project" do
        @title = "New task list in project "+@project.name
      end

      it "should render template new" do
        response.should render_template :new
      end

    end

    describe "without project" do

      before(:each) do
        TaskList.stub!(:new).and_return @task_list
        get :new
      end

      it "should assigns title new in project" do
        @title = "New task list"
      end

      it "should render template new" do
        response.should render_template :new
      end

    end

  end

  describe "POST 'create'" do

    describe "with project" do

    end

  end


  describe "POST 'create'" do

    describe "with project" do

      describe "with valid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :new).and_return @task_list
          @task_list.stub!(:save).and_return @task_list
          post :create, project_id: @project.id, task_list: @task_list
        end

        it "should have flash success" do
          flash[:success].should == "Task list was successful created"
        end

        it "should redirect to project task lists path" do
          response.should redirect_to project_task_lists_path(@project)
        end

      end


      describe "with invalid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :new).and_return @task_list_invalid
          @task_list.stub!(:save).and_return @task_list_invalid
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
          TaskList.stub!(:save).and_return @task_list
          post :create, task_list: @task_list
        end

        it "should have flash success" do
          flash[:success].should == "Task list was successful created"
        end

        it "should redirect to project task lists path" do
          response.should redirect_to task_lists_path
        end

      end


      describe "with invalid data" do

        before(:each) do
          TaskList.stub!(:new).and_return @task_list_invalid
          TaskList.stub!(:save).and_return @task_list_invalid
          post :create, task_list: @task_list_invalid
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

    describe "with project" do

      before(:each) do
        Project.stub!(:find).and_return @project
        @project.stub_chain(:task_lists, :find).and_return @task_list
        get :edit, id: @task_list.id, project_id: @project.id
      end

      it "should assign title Edit task list in project " do
        assigns(:title).should == "Edit "+@task_list.name+" in "+@project.name
      end

      it "should render template 'edit'" do
        response.should render_template :edit
      end

    end

    describe "without project" do

      before(:each) do
        TaskList.stub!(:find).and_return @task_list
        get :edit, id: @task_list.id
      end

      it "should assign title Edit task list in project " do
        assigns(:title).should == "Edit "+@task_list.name
      end

      it "should render template 'edit'" do
        response.should render_template :edit
      end

    end

  end

  describe "POST 'update'" do

    describe "with project" do

      describe "with valid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:update_attributes).and_return @task_list
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list
        end

        it "should have flash success" do
          flash[:success].should == "Task list was successful updated"
        end

        it "should redirect to project task lists path" do
          response.should redirect_to([@project, @task_list])
        end

      end


      describe "with invalid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list_invalid
          @task_list_invalid.stub!(:update_attributes).and_return false
          post :update, project_id: @project.id, id: @task_list.id, task_list: @task_list_invalid
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
          @task_list.stub!(:update_attributes).and_return @task_list
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
          post :update, id: @task_list.id, task_list: @task_list_invalid
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
    describe "with project" do

      describe "with valid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:destroy).and_return @task_list
          get :destroy, project_id: @project.id, id: @task_list.id
        end

        it "should have flash success" do
          flash[:success].should == 'Task list '+@task_list.name+' was successfully destroyed'
        end

        it "should redirect to project task lists path" do
          response.should redirect_to project_task_lists_path(@project)
        end

      end

      describe "with invalid data" do

        before(:each) do
          Project.stub!(:find).and_return @project
          @project.stub_chain(:task_lists, :find).and_return @task_list
          @task_list.stub!(:destroy).and_return false
          get :destroy, project_id: @project.id, id: @task_list.id
        end

        it "should have flash error" do
          flash[:error].should == 'Error task list destroy'
        end

        it "should redirect to project task lists path" do
          response.should redirect_to project_task_lists_path(@project)
        end

      end
    end


    describe "without project" do

      describe "with valid data" do

        before(:each) do
          TaskList.stub!(:find).and_return @task_list
          @task_list.stub!(:destroy).and_return @task_list
          get :destroy, id: @task_list.id
        end

        it "should have flash success" do
          flash[:success].should == 'Task list '+@task_list.name+' was successfully destroyed'
        end

        it "should redirect to project task lists path" do
          response.should redirect_to task_lists_path
        end

      end

      describe "with invalid data" do

        before(:each) do
          TaskList.stub!(:find).and_return @task_list
          @task_list.stub!(:destroy).and_return false
          get :destroy, id: @task_list.id
        end

        it "should have flash error" do
          flash[:error].should == 'Error task list destroy'
        end

        it "should redirect to project task lists path" do
          response.should redirect_to task_lists_path
        end

      end

    end

  end

end