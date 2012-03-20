class TasksController < ApplicationController

  def index
    @task_list = TaskList.find params[:task_list_id]
    params[:state].nil?? @tasks = @task_list.task : @tasks = @task_list.task.where("state = ?", params[:state])
    @title = "Tasks of "+@task_list.name
  end

  def show
    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.task.find(params[:id])
    @title = @task.name
  end

  def new
    @task_list = TaskList.find(params[:task_list_id])
    @project = @task_list.project
    if @project
      @performers = @project.users if @project.users.count > 1
    end
    @task = @task_list.task.new
    @title = "New task in "+@task_list.name
 end

 def edit
   @task_list = TaskList.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
   @project = @task_list.project
   if @project
     @performers = @project.users if @project.users.count > 1
   end
   @title = "Edit task "+@task.name+" in "+@task_list.name
 end

 def create
   @task_list = TaskList.find(params[:task_list_id])
   @task = @task_list.task.new(params[:task])
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
   @task_list = TaskList.find(params[:task_list_id])
   @project = @task_list.project
   @task = @task_list.task.find(params[:id])
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
   @task_list = TaskList.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
   if @task.destroy
     flash[:success] = 'Task '+@task.name+' was successfully destroyed'
   else
     flash[:error] = 'Error task destroy'
   end
   redirect_to task_list_tasks_path
 end

  def change_state
    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.task.find(params[:id])
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
