class PagesController < ApplicationController
  def home
    if signed_in?
      @title =  current_user.name + " todo list"
      @user = current_user
      @projects_item = current_user.projects
      @task_lists_item = current_user.task_lists.where("project_id IS NULL")
    else
      @user = User.new
      @title = "Todo list sign up"
    end
  end

  def access
    @title = "Access denied"
  end

end
