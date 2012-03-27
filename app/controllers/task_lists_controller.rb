class TaskListsController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :task_list, :through => :project, :shallow => true

  def index
    if @project
      @title += ' of project '+@project.name
      @task_lists = @project.task_lists
    else
      @task_lists = current_user.task_lists.where('project_id IS NULL')
    end
  end

  def show

  end

  def new

  end

  def edit

  end

  def create
    if @task_list.save
      flash[:success] = "Task list was successful created"
      @project? redirect_to(project_task_lists_path) : redirect_to(task_lists_path)
    else
      flash[:error] = "Error task list create"
      render 'new'
    end
  end

  def update
    if @task_list.update_attributes params[:task_list]
      flash[:success] = "Task list was successful updated"
      @project? redirect_to([@project, @task_list]) : redirect_to(@task_list)
    else
      flash[:error] = "Error task list update"
      render 'edit'
    end
  end

  def destroy
    if @task_list.destroy
      flash[:success] = 'Task list '+@task_list.name+' was successfully destroyed'
    else
      flash[:error] = 'Error task list destroy'
    end
    @project? redirect_to(project_task_lists_path): redirect_to(task_lists_path)
  end
end
