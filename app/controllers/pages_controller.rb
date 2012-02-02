class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @projects_item = current_user.projects
      @relationship = Relationship.where("follower_id = ?", current_user.id)
      @projects_follower_item = @relationship.map{ |relation| Project.find_by_id(relation.project_id)}
      @task_lists_item = current_user.task_lists.where("project_id IS NULL")
    end
  end

  def about
    @title = "About"
  end

  def access

  end

end
