require 'spec_helper'

describe TasksController do

  before(:each) do

    @user = Factory.create(:user)
    sign_in @user

    @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)

    @task_list =  mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: true)
    TaskList.stub!(:find).and_return @task_list

    @task =  mock_model(Task,  id: 1, name: 'TaskList name', task_list_id: @task_list.id, save: true)
    @task_params =  {name: 'TaskList name' }

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }

  end

  describe "GET 'index'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :read, Task
      get :index, task_list_id: @task_list.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :read, Task
    end

    describe "with state" do

      before(:each) do
        @tasks = [@task, @task]
        @task_list.stub_chain(:tasks, :where).and_return @tasks
      end

      it "should receive tasks" do
        @task_list.tasks.should_receive(:where).and_return @tasks
        get :index, task_list_id: @task_list.id, state: 'in_process'
      end

      it "should assign tasks" do
        get :index, task_list_id: @task_list.id, state: 'in_process'
        assigns(:tasks).should == @tasks
      end

      it "should render template index" do
        get :index, task_list_id: @task_list.id, state: 'in_process'
        response.should render_template :index
      end

    end

    describe "without state" do

      before(:each) do
        @tasks = [@task, @task, @task]
        @task_list.stub!(:tasks).and_return @tasks
      end

      it "should receive find" do
        @task_list.should_receive(:tasks).and_return @tasks
        get :index, task_list_id: @task_list.id
      end

      it "should assign tasks" do
        get :index, task_list_id: @task_list.id
        assigns(:tasks).should == @tasks
      end

      it "should render template index" do
        get :index, task_list_id: @task_list.id
        response.should render_template :index
      end

    end

  end

  describe "GET 'show'"  do

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :read, Task
      get :index, task_list_id: @task_list.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :read, Task
      @task_list.stub_chain(:tasks, :find).and_return @task
    end

    it "should receive find" do
      @task_list.tasks.should_receive(:find).and_return @task
      get :show, task_list_id: @task_list.id, id: @task.id
    end

    it "should assigns task" do
      get :show, task_list_id: @task_list.id, id: @task.id
      assigns(:task).should == @task
    end

    it "should render template show" do
      get :show, task_list_id: @task_list.id, id: @task.id
      response.should render_template :show
    end
  end


  describe "GET 'new'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :manage, Task
      get :new, task_list_id: @task_list.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :manage, Task
    end

    describe "task list in project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @project.stub!(:users).and_return [@user, @user]
        @task_list.stub_chain(:tasks, :new).and_return @task
      end

      it "should receive new" do
        @task_list.tasks.should_receive(:new).and_return @task
        get :new, task_list_id: @task_list.id
      end

      it "should assigns task" do
        get :new, task_list_id: @task_list.id
        assigns(:task).should == @task
      end

      it "should receive users" do
        @project.should_receive(:users).and_return [@user, @user]
        get :new, task_list_id: @task_list.id
      end

      it "should not have performers" do
        get :new, task_list_id: @task_list.id
        assigns(:performers).should == [@user, @user]
      end

      it "should render template new" do
        get :new, task_list_id: @task_list.id
        response.should render_template :new
      end

    end

    describe "task list without project" do

      before(:each) do
        @task_list.stub!(:project).and_return nil
        @task_list.stub_chain(:tasks, :new).and_return @task
        get :new, task_list_id: @task_list.id
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

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :manage, Task
      get :edit, task_list_id: @task_list.id, id: @task.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :manage, Task
    end


    describe "task list in project" do

      before(:each) do
        @task_list.stub!(:project).and_return @project
        @project.stub!(:users).and_return [@user, @user]
        @task_list.stub_chain(:tasks, :find).and_return @task
      end

      it "should receive find" do
       @task_list.tasks.should_receive(:find).and_return @task
       get :edit, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        get :edit, task_list_id: @task_list.id, id: @task.id
        assigns(:task).should == @task
      end

      it "should receive users" do
        @project.should_receive(:users).and_return [@user, @user]
        get :edit, task_list_id: @task_list.id, id: @task.id
      end

      it "should not have performers" do
        get :edit, task_list_id: @task_list.id, id: @task.id
        assigns(:performers).should == [@user, @user]
      end

      it "should render template edit" do
        get :edit, task_list_id: @task_list.id, id: @task.id
        response.should render_template :edit
      end

    end

    describe "task list without project" do

      before(:each) do
        @task_list.stub!(:project).and_return nil
        @task_list.stub_chain(:tasks, :find).and_return @task
        get :edit, task_list_id: @task_list.id, id: @task.id
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

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :manage, Task
      post :create, task_list_id: @task_list.id, task: @task_params
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :manage, Task
    end

    describe "with valid data" do

      before(:each) do
        @task_list.stub(:project).and_return nil
        @task_list.stub_chain(:tasks, :new).and_return @task
        @task.stub!(:save).and_return true
      end

      it "should receive new" do
        @task_list.tasks.should_receive(:new).and_return @task
        post :create, task_list_id: @task_list.id, task: @task_params
      end

      it "should assigns task" do
        post :create, task_list_id: @task_list.id, task: @task_params
        assigns(:task).should == @task
      end

      it "should receive save" do
        @task.should_receive(:save).and_return @task
        post :create, task_list_id: @task_list.id, task: @task_params
      end

      it "should have flash success" do
        post :create, task_list_id: @task_list.id, task: @task_params
        flash[:success].should == 'Task was successfully created'
      end

      it "should redirect to task list task  path" do
        post :create, task_list_id: @task_list.id, task: @task_params
        response.should redirect_to [@task_list, @task]
      end

    end

    describe "with invalid data" do

      before(:each) do
        @task_list.stub(:project).and_return nil
        @task_list.stub_chain(:tasks, :new).and_return @task
        @task.stub!(:save).and_return false
        post :create, task_list_id: @task_list.id, task: @task_params
      end

      it "should have flash error" do
        flash[:error].should == 'Error task create'
      end

      it "should render template new" do
        response.should render_template :new
      end

    end

  end

  describe "POST 'update'"  do

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :manage, Task
      post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :manage, Task
    end

    describe "with valid data" do

      before(:each) do
        @task_list.stub(:project).and_return nil
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:update_attributes).and_return true
      end

      it "should receive find" do
        @task_list.tasks.should_receive(:find).and_return @task
        post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
      end

      it "should assigns task" do
        post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
        assigns(:task).should == @task
      end

      it "should receive update" do
        @task.should_receive(:update_attributes).and_return true
        post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
      end

      it "should have flash success" do
        post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
        flash[:success].should == 'Task was successfully updated'
      end

      it "should redirect to task list task path" do
        post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
        response.should redirect_to [@task_list, @task]
      end

    end

    describe "with invalid data" do

      before(:each) do
        @task_list.stub(:project).and_return nil
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:update_attributes).and_return false
        post :update, task_list_id: @task_list.id, id: @task.id, task: @task_params
      end

      it "should have flash error" do
        flash[:error].should == 'Error task update'
      end

      it "should render template edit" do
        response.should render_template :edit
      end

    end

  end


  describe "GET 'destroy'" do

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :manage, Task
      get :destroy, task_list_id: @task_list.id, id: @task.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :manage, Task
    end

    describe "with valid task" do

      before(:each) do
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:destroy).and_return @task
      end

      it "should receive find" do
        @task_list.tasks.should_receive(:find).and_return @task
        get :destroy, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        get :destroy, task_list_id: @task_list.id, id: @task.id
        assigns(:task).should == @task
      end

      it "should receive destroy" do
        @task.should_receive(:destroy).and_return @task
        get :destroy, task_list_id: @task_list.id, id: @task.id
      end


      it "should have flash success" do
        get :destroy, task_list_id: @task_list.id, id: @task.id
        flash[:success].should == 'Task '+@task.name+' was successfully destroyed'
      end

      it "should redirect to task list tasks path" do
        get :destroy, task_list_id: @task_list.id, id: @task.id
        response.should redirect_to task_list_tasks_path
      end

    end



    describe "with invalid task" do

      before(:each) do
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:destroy).and_return false
        get :destroy, task_list_id: @task_list.id, id: @task.id
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

    it "should redirect to access page without ability" do
      @ability.cannot :read, TaskList
      @ability.cannot :manage, Task
      get :change_state, task_list_id: @task_list.id, id: @task.id
      response.should redirect_to access_url
    end

    before(:each) do
      @ability.can :read, TaskList
      @ability.can :manage, Task
    end


    describe "with valid data" do

      before(:each) do
        @task_list.stub(:project).and_return nil
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:change_state).and_return true
      end

      it "should receive find" do
        @task_list.tasks.should_receive(:find).and_return @task
        get :change_state, task_list_id: @task_list.id, id: @task.id
      end

      it "should assigns task" do
        get :change_state, task_list_id: @task_list.id, id: @task.id
        assigns(:task).should == @task
      end

      it "should receive change_state" do
        @task.should_receive(:change_state).and_return true
        get :change_state, task_list_id: @task_list.id, id: @task.id
      end

      it "should have flash success" do
        get :change_state, task_list_id: @task_list.id, id: @task.id
        flash[:success].should == 'Task '+@task.name+' state was successfully updated'
      end

      it "should redirect to task list tasks path" do
        get :change_state, task_list_id: @task_list.id, id: @task.id
        response.should redirect_to task_list_tasks_path(@task_list)
      end

    end

    describe "with invalid data" do

      before(:each) do
        @task_list.stub(:project).and_return nil
        @task_list.stub_chain(:tasks, :find).and_return @task
        @task.stub!(:change_state).and_return false
        get :change_state, task_list_id: @task_list.id, id: @task.id
      end

      it "should have flash error" do
        flash[:error].should == 'Error change task state'
      end

      it "should redirect to task list tasks path" do
        response.should redirect_to task_list_tasks_path(@task_list)
      end

    end

  end

end