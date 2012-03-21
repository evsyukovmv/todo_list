class TasksController < ApplicationController

  load_and_authorize_resource :task_list
  load_and_authorize_resource :task, :through => :task_list

  def index
    params[:state]? @tasks = @task_list.tasks.where("state = ?", params[:state]) : @tasks = @task_list.tasks
    @title = "Tasks of "+@task_list.name
  end

  def show
    @title = @task.name
  end

  def new
    @project = @task_list.project
    if @project
      @performers = @project.users if @project.users.count > 1
    end
    @title = "New task in "+@task_list.name
  end

  def edit
    @project = @task_list.project
    if @project
      @performers = @project.users if @project.users.count > 1
    end
    @title = "Edit task "+@task.name+" in "+@task_list.name
  end

  def create
    @project = @task_list.project if @task_list.project
    Mailer.changed(@task.user, @project.name, @task.name).deliver if @task.performer_id
    if @task.save
      flash[:success] = 'Task was successfully created'
      redirect_to [@task_list, @task]
    else
      flash[:error] = 'Error task create'
      render 'new'
    end
  end

  def update
    @project = @task_list.project
    if @task.update_attributes(params[:task])
      Mailer.changed(@task.user, @project.name, @task.name).deliver if @task.performer_id
      flash[:success] = 'Task was successfully updated'
      redirect_to [@task_list, @task]
    else
      flash[:error] = 'Error task update'
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = 'Task '+@task.name+' was successfully destroyed'
    else
      flash[:error] = 'Error task destroy'
    end
    redirect_to task_list_tasks_path
  end

  def change_state
    @project = @task_list.project if @task_list.project
    if @task.change_state
      if @project and @task.performer_id
        Mailer.changed(@task.user, @project.name, @task.name).deliver
      end
      flash[:success] = 'Task '+@task.name+' state was successfully updated'
    else
      flash[:error] = 'Error change task state'
    end
    redirect_to task_list_tasks_path
  end

end
