module RSpecControllerMocksStubs
  extend ActiveSupport::Concern
  included do
    before do
      @user = mock_model(User, name: 'user name', email: 'email@email.com', save: true)
      @project =  mock_model(Project,  id: 1, name: 'name', save: true)

      @user.stub!(:projects).and_return @project
      @project.stub!(:user_id=)
      @project.stub!(:users).and_return [@user]
      controller.stub!(:current_user).and_return @user
      User.stub!(:find_by_email).and_return @user

      Project.stub!(:find).and_return @project
      Project.stub!(:new).and_return @project
    end
  end
end