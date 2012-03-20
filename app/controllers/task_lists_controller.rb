class TaskListsController < ApplicationController


  def index
    @project = Project.find params[:project_id] if params[:project_id]
    if @project
      @title = 'All task lists of project '+@project.name
      @task_lists = @project.task_lists
    else
      @title = 'All task lists'
      @task_lists = current_user.task_lists.where('project_id IS NULL')
    end
  end

  def show
    if params[:project_id]
      @project = Project.find params[:project_id]
      @task_list = @project.task_lists.find params[:id]
      @title = @task_list.name + ' of '+@project.name
    else
      @task_list = current_user.task_lists.find params[:id]
      @title = @task_list.name
    end
  end

  def new
    if params[:project_id]
      @project = current_user.project params[:project_id]
      @title = "New task list in project "+@project.name
      @task_list = @project.task_lists.new
    else
      @title = "New task list"
      @task_list = current_user.task_lists.new
    end
  end

  def edit
    if params[:project_id]
      @project = current_user.project params[:project_id]
      @task_list = @project.task_lists.find params[:id]
      @title = "Edit "+@task_list.name+" in "+@project.name
    else
      @task_list = current_user.task_lists.find params[:id]
      @title = "Edit "+@task_list.name
    end
  end

  def create
    @task_list = current_user.task_lists.new params[:task_list]
    if params[:project_id]
      @project = current_user.project params[:project_id]
      @task_list.project_id = @project.id
    end

    if @task_list.save
      flash[:success] = "Task list was successful created."
      @project.nil? ? redirect_to(task_lists_path) : redirect_to(project_task_lists_path)
    else
      flash[:error] = "Error task list create!"
      render 'new'
    end
  end

  def update
    if params[:project_id]
      @project = current_user.project params[:project_id]
      @task_list = @project.task_lists.find params[:id]
    else
      @task_list = current_user.task_lists.find params[:id]
    end
    if @task_list.update_attributes params[:task_list]
      flash[:success] = "Task list was successful updated."
      if @project
        redirect_to [@project, @task_list]
      else
        redirect_to @task_list
      end
    else
      flash[:error] = "Error task list update."
      render 'edit'
    end
  end

  def destroy
    if params[:project_id]
      @project = current_user.project params[:project_id]
      @task_list = @project.task_lists.find params[:id]
    else
      @task_list = current_user.task_lists.find params[:id]
    end
    if @task_list.destroy
      flash[:success] = 'Task list '+@task_list.name+' was successfully destroyed.'
    else
      flash[:error] = 'Error task list destroy'
    end
    @project ? redirect_to(project_task_lists_path): redirect_to(task_lists_path)
  end
end
