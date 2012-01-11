class TaskListsController < ApplicationController
   def index
    @task_lists = TaskList.all
    @title = "All task lists"
  end

  def show
    @task_lists = TaskList.find(params[:id])
    @title = @task_lists.name
  end

end
