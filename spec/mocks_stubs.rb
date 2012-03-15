module RSpecControllerMocksStubs
  extend ActiveSupport::Concern
  included do
    before do
      @user = mock_model(User, name: 'user name', email: 'email@email.com', password: 'password', save: true)
      controller.stub!(:current_user).and_return @user
      User.stub!(:find_by_email).and_return @user

      @project =  mock_model(Project,  id: 1, name: 'Project name', save: true)
      @project_invalid =  mock_model(Project,  id: 1, name: 'Project name', save: false, destroy: false)
      @project_invalid.stub!(:user_id=)
      @project.stub!(:update_attributes).and_return true
      @project_invalid.stub!(:update_attributes).and_return false
      Project.stub!(:find).and_return @project
      Project.stub!(:new).and_return @project
      @project.stub!(:user_id=)
      @project.stub!(:users).and_return [@user]
      @project_invalid.stub!(:users).and_return [@user]
      @user.stub!(:projects).and_return @project
      @project.stub!(:destroy).and_return @project

      @task_list =  mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: true)
      @task_list_invalid = mock_model(TaskList,  id: 1, name: 'TaskList name', user_id: @user.id, save: false, destroy: false)
      @task_list.stub!(:update_attributes).and_return true
      @task_list_invalid.stub!(:update_attributes).and_return false
      @user.stub!(:task_lists).and_return @task_list
      @user.stub_chain(:task_lists, :where).and_return @task_list
      @project.stub!(:task_lists).and_return @task_list
      @project.stub_chain(:task_lists, :find).and_return @task_list
      TaskList.stub!(:find).and_return @task_list
      @project.stub_chain(:task_lists, :new).and_return @task_list
      TaskList.stub!(:new).and_return @task_list
      @task_list.stub!(:project_id=).and_return @project.id
      @task_list.stub!(:destroy).and_return @task_list
    end
  end
end