class TasksController < ApplicationController

  load_and_authorize_resource :task_list
  load_and_authorize_resource :task, :through => :task_list

  def index
    params[:state]? @tasks = @task_list.tasks.where("state = ?", params[:state]) : @tasks = @task_list.tasks
  end

  def show

  end

  def new
    @project = @task_list.project
    if @project
      @performers = @project.users if @project.users.count > 1
    end
  end

  def edit
    @project = @task_list.project
    if @project
      @performers = @project.users if @project.users.count > 1
    end
  end

  def create
    if @task.save
      flash[:success] = 'Task was successfully created'
      redirect_to [@task_list, @task]
    else
      flash[:error] = 'Error task create'
      render 'new'
    end
  end

  def update
    if @task.update_attributes(params[:task])
      flash[:success] = 'Task was successfully updated'
      redirect_to [@task_list, @task]
    else
      flash[:error] = 'Error task update'
      render 'edit'
    end
  end

  def destroy
    @task.destroy ? flash[:success] = 'Task '+@task.name+' was successfully destroyed' : flash[:error] = 'Error task destroy'
    redirect_to task_list_tasks_path
  end

  def change_state
    if @task.change_state
      flash[:success] = 'Task '+@task.name+' state was successfully updated'
    else
      flash[:error] = 'Error change task state'
    end
    redirect_to task_list_tasks_path
  end

end
