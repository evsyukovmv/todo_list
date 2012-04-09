require 'spec_helper'

describe "pages/home.html.haml" do

  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  describe "user not signed in" do

    before(:each) do
      render
    end

    it "should have email field" do
      rendered.should have_selector("input", type: "email", name: "user[email]")
    end

    it "should have password field" do
      rendered.should have_selector("input", type: "password", name: "user[password]")
    end

    it "should have sign in button" do
      rendered.should have_selector("input", type: "submit", value: "Sign in")
    end

    it "should have sign up link" do
      rendered.should have_selector("a", content: "Sign up")
    end

  end

  describe "user signed in" do

    before(:each) do

      @user = Factory.create(:user)
      sign_in @user

      @project = mock_model(Project)
      @projects = [@project, @project, @project]

      @task_list = mock_model(TaskList)
      @task_lists = [@task_list, @task_list, @task_list]

      render

    end

    it "should render error messages template" do
      view.should render_template(partial: 'shared/_error_messages')
    end

    it "should render project and task lists" do
      view.should render_template(partial: 'shared/_projects_task_lists')
    end



  end



end