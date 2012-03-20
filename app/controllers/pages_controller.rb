class PagesController < ApplicationController
  def home
    if signed_in?
      @title = "Todo list"
      @user = current_user
      @projects = current_user.projects
      @task_lists = current_user.task_lists.where("project_id IS NULL")
    else
      @user = User.new
      @title = "Todo list sign up"
    end
  end

  def access
    @title = "Access denied"
  end

end
