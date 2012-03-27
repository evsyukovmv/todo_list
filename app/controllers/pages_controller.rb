class PagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      @projects = current_user.projects
      @task_lists = current_user.task_lists.where("project_id IS NULL")
    else
      @user = User.new
    end
  end

  def access
  end

end
