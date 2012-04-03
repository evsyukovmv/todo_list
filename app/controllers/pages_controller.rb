class PagesController < ApplicationController
  def home
    if signed_in?
      @projects = current_user.projects
      @task_lists = current_user.task_lists.where("project_id IS NULL")
      @projects.each do |project|
        @task_lists = (@task_lists| project.task_lists).compact
      end
      @tasks = Array.new
      @task_lists.each do |task_list|
        @tasks = (@tasks | task_list.tasks).compact
      end
    else
      @user = User.new
    end
  end

  def access
  end

end
