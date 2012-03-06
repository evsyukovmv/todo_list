class PagesController < ApplicationController
  def home
    @title = "Todo list"
    if signed_in?
      @user = current_user
      @projects_item = current_user.projects
      @task_lists_item = current_user.task_lists.where("project_id IS NULL")
    else
      @user = User.new
      @title = "Sign up"
    end
  end

  def about
    @title = "About"
  end

  def access

  end

end
