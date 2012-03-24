require 'spec_helper'

describe TasksController do

  before(:each) do

    @user = Factory.create(:user)
    sign_in @user

    @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)

    @task_list =  mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: true)
    TaskList.stub!(:find).and_return @task_list

    @task =  mock_model(Task,  id: 1, name: 'TaskList name', task_list_id: @task_list.id, save: true)
    @task_invalid =  mock_model(Task,  id: 1, name: 'TaskList name', task_list_id: @task_list.id, save: false, destroy: false)

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

    @ability.can :manage, TaskList
    @ability.can :manage, Task

  end

  describe "GET 'index'" do
    describe "with state" do

      before(:each) do
        @tasks = [@task, @task]
        @task_list.stub_chain(:tasks, :where).and_return @tasks
        get :index, task_list_id: @task_list.id, state: 'in_process'
      end

      it "should assign tasks" do
        assigns(:tasks).should == @tasks
      end

      it "should render template index" do
        response.should render_template :index
      end

    end

    describe "without state" do

      before(:each) do
        @tasks = [@task, @task, @task]
        @task_list.stub!(:tasks).and_return @tasks
        get :index, task_list_id: @task_list.id
      end

      it "should assign tasks" do
        assigns(:tasks).should == @tasks
      end

      it "should render template index" do
        response.should render_template :index
      end

    end

  end

  describe "GET 'show'"  do
    before(:each) do
      @task_list.stub_chain(:tasks, :find).and_return @task
      get :show, task_list_id: @task_list.id, id: @task.id
    end

    it "should assigns task" do
      assigns(:task).should == @task
    end

    it "should have title task" do
      assigns(:title).should == @task.name
    end

    it "should render template show" do
      response.should render_template :show
    end
  end


  describe "GET 'new'" do

    describe "task list in project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @project.stub!(:users).and_return [@user, @user]
        @task_list.stub_chain(:tasks, :new).and_return @task
        get :new, task_list_id: @task_list.id
      end

      it "should assigns task" do
        assigns(:task).should == @task
      end

      it "should not have performers" do
        assigns(:performers).should == [@user, @user]
      end

      it "should have title New task in task list" do
        assigns(:title).should == "New task in "+@task_list.name
      end

      it "should render template new" do
        response.should render_template :new
      end

    end

    describe "task list without project" do

      before(:each) do
        @task_list.stub!(:project).and_return nil
        @task_list.stub_chain(:tasks, :new).and_return @task
        get :new, task_list_id: @task_list.id
      end

      it "should assigns task" do
        assigns(:task).should == @task
      end

      it "should have title New task in task list" do
        assigns(:title).should == "New task in "+@task_list.name
      end

      it "should not have performers" do
        assigns(:performers).should be_nil
      end

      it "should render template new" do
        response.should render_template :new
      end

    end

  end

  describe "GET 'edit'" do

    describe "task list in project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @project.stub!(:users).and_return [@user, @user]
        @task_list.stub_chain(:tasks, :find).and_return @task
        get :edit, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        assigns(:task).should == @task
      end

      it "should not have performers" do
        assigns(:performers).should == [@user, @user]
      end

      it "should have title New task in task list" do
        assigns(:title).should == "Edit task "+@task.name+" in "+@task_list.name
      end

      it "should render template edit" do
        response.should render_template :edit
      end

    end

    describe "task list without project" do

      before(:each) do
        @task_list.stub!(:project).and_return nil
        @task_list.stub_chain(:tasks, :find).and_return @task
        get :edit, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        assigns(:task).should == @task
      end

      it "should have title New task in task list" do
        assigns(:title).should == "Edit task "+@task.name+" in "+@task_list.name
      end

      it "should not have performers" do
        assigns(:performers).should be_nil
      end

      it "should render template edit" do
        response.should render_template :edit
      end

    end

  end


  describe "POST 'create'"  do

    describe "without project" do

      describe "with valid data" do

        before(:each) do
          @task_list.stub(:project).and_return nil
          @task_list.stub_chain(:tasks, :new).and_return @task
          @task.stub!(:save).and_return @task
          post :create, task_list_id: @task_list.id
        end

        it "should assigns task" do
          assigns(:task).should == @task
        end

        it "should have flash success" do
          flash[:success].should == 'Task was successfully created'
        end

        it "should redirect to task list task  path" do
          response.should redirect_to [@task_list, @task]
        end

      end

      describe "with invalid data" do

        before(:each) do
          @task_list.stub(:project).and_return nil
          @task_list.stub_chain(:tasks, :new).and_return @task_invalid
          @task.stub!(:save).and_return @task_invalid
          post :create, task_list_id: @task_list.id
        end

        it "should assigns task" do
          assigns(:task).should == @task_invalid
        end

        it "should have flash error" do
          flash[:error].should == 'Error task create'
        end

        it "should render template new" do
          response.should render_template :new
        end

      end

    end

    describe "with project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @task_list.stub_chain(:tasks, :new).and_return @task
        @task.stub!(:save).and_return @task
      end

      it "should send email if set performer" do
        @task.stub!(:performer_id).and_return 1
        @task.stub!(:user).and_return @user
        Mailer.stub_chain(:changed, :deliver)
        Mailer.should_receive(:changed).with(@user, @project.name, @task.name)
        post :create, task_list_id: @task_list.id
      end

      it "should not send mail it has not performer" do
        @task.stub!(:performer_id).and_return nil
        Mailer.stub_chain(:changed, :deliver)
        Mailer.should_not_receive(:changed).with(@user, @project.name, @task.name)
        post :create, task_list_id: @task_list.id
      end

    end

  end

  describe "POST 'update'"  do

    describe "without project" do

      describe "with valid data" do

        before(:each) do
          @task_list.stub(:project).and_return nil
          @task_list.stub_chain(:tasks, :find).and_return @task
          @task.stub!(:update_attributes).and_return @task
          post :update, task_list_id: @task_list.id, id: @task.id
        end

        it "should assigns task" do
          assigns(:task).should == @task
        end

        it "should have flash success" do
          flash[:success].should == 'Task was successfully updated'
        end

        it "should redirect to task list task path" do
          response.should redirect_to [@task_list, @task]
        end

      end

      describe "with invalid data" do

        before(:each) do
          @task_list.stub(:project).and_return nil
          @task_list.stub_chain(:tasks, :find).and_return @task_invalid
          @task_invalid.stub!(:update_attributes).and_return false
          post :update, task_list_id: @task_list.id, id: @task.id
        end

        it "should assigns task" do
          assigns(:task).should == @task_invalid
        end

        it "should have flash error" do
          flash[:error].should == 'Error task update'
        end

        it "should render template edit" do
          response.should render_template :edit
        end

      end

    end

    describe "with project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:update_attributes).and_return @task
      end

      it "should send email if set performer" do
        @task.stub!(:performer_id).and_return 1
        @task.stub!(:user).and_return @user
        Mailer.stub_chain(:changed, :deliver)
        Mailer.should_receive(:changed).with(@user, @project.name, @task.name)
        post :update, task_list_id: @task_list.id, id: @task.id
      end

      it "should not send mail it has not performer" do
        @task.stub!(:performer_id).and_return nil
        Mailer.stub_chain(:changed, :deliver)
        Mailer.should_not_receive(:changed).with(@user, @project.name, @task.name)
        post :update, task_list_id: @task_list.id, id: @task.id
      end

    end

  end


  describe "GET 'destroy'" do


    describe "with valid task" do

      before(:each) do
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:destroy).and_return @task
        get :destroy, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        assigns(:task).should == @task
      end

      it "should have flash success" do
        flash[:success].should == 'Task '+@task.name+' was successfully destroyed'
      end

      it "should redirect to task list tasks path" do
        response.should redirect_to task_list_tasks_path
      end

    end



    describe "with invalid task" do

      before(:each) do
        @task_list.stub_chain(:tasks, :find).and_return @task_invalid
        @task.stub!(:destroy).and_return @task_invalid
        get :destroy, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        assigns(:task).should == @task_invalid
      end

      it "should have flash success" do
        flash[:error].should == 'Error task destroy'
      end

      it "should redirect to task list tasks path" do
        response.should redirect_to task_list_tasks_path
      end

    end

  end


  describe "GET 'change_state'"  do

    describe "without project" do

      describe "with valid data" do

        before(:each) do
          @task_list.stub(:project).and_return nil
          @task_list.stub_chain(:tasks, :find).and_return @task
          @task.stub!(:change_state).and_return @task
          get :change_state, task_list_id: @task_list.id, id: @task.id
        end

        it "should assigns task" do
          assigns(:task).should == @task
        end

        it "should have flash success" do
          flash[:success].should == 'Task '+@task.name+' state was successfully updated'
        end

        it "should redirect to task list tasks path" do
          response.should redirect_to task_list_tasks_path(@task_list)
        end

      end

      describe "with invalid data" do

        before(:each) do
          @task_list.stub(:project).and_return nil
          @task_list.stub_chain(:tasks, :find).and_return @task_invalid
          @task_invalid.stub!(:change_state).and_return false
          get :change_state, task_list_id: @task_list.id, id: @task.id
        end

        it "should assigns task" do
          assigns(:task).should == @task_invalid
        end

        it "should have flash error" do
          flash[:error].should == 'Error change task state'
        end

        it "should redirect to task list tasks path" do
          response.should redirect_to task_list_tasks_path(@task_list)
        end

      end

    end

    describe "with project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:change_state).and_return @task
      end

      it "should send email if set performer" do
        @task.stub!(:performer_id).and_return 1
        @task.stub!(:user).and_return @user
        Mailer.stub_chain(:changed, :deliver)
        Mailer.should_receive(:changed).with(@user, @project.name, @task.name)
        get :change_state, task_list_id: @task_list.id, id: @task.id
      end

      it "should not send mail it has not performer" do
        @task.stub!(:performer_id).and_return nil
        Mailer.stub_chain(:changed, :deliver)
        Mailer.should_not_receive(:changed).with(@user, @project.name, @task.name)
        get :change_state, task_list_id: @task_list.id, id: @task.id
      end

    end

  end

end