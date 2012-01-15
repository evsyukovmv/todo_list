class TaskListsController < ApplicationController
   def index
    @task_lists = TaskList.all
    @title = "All task lists"
  end

  def show
    @task_list = TaskList.find(params[:id])
    @title = @task_list.name
  end

  def new
    @task_list = TaskList.new
  end

  def edit
    @task_list = TaskList.find(params[:id])
  end

  def create
    @task_list = TaskList.new(params[:task_list])
    if @task_list.save
      redirect_to @task_list, notice: 'Task list was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @task_list = TaskList.find(params[:id])
    if @task_list.update_attributes(params[:task_list])
      redirect_to @task_list, notiece: 'Task list was successfully updated.'
    else
      render action: edit
    end
  end

  def destroy
    @task_list = TaskList.find(params[:id])
    @task_list.destroy

    redirect_to task_lists_path
  end

end
