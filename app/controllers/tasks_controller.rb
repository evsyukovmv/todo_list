class TasksController < ApplicationController
  before_filter :authorized_user
  def index
    @task_list = TaskList.find(params[:task_list_id])
    if params[:state] == 'done'
      @title = "Done"
      @tasks = @task_list.task.where("state = 'Done'").order "id DESC"
    elsif params[:state] == 'inprocess'
      @title = "In process"
      @tasks = @task_list.task.where("state = 'In process'").order "id DESC"
    elsif params[:state] == 'notdone'
      @title = "Not done"
      @tasks = @task_list.task.where("state = 'Not done'").order "id DESC"
    else
      @title = "All"
      @tasks = @task_list.task.order "id DESC"
    end
    @title += " tasks of "+@task_list.name
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

    if @task.state == :"Not done"
      @task.state = :"In process"
    elsif @task.state == :"In process"
      @task.state = :"Done"
    else
      @task.state = :"Not done"
    end

    if @task.save
      if @project and @task.performer_id
        Mailer.changed(@task.user, @project.name, @task.name).deliver
      end
      flash[:success] = 'Task '+@task.name+' state was successfully updated.'
    else
      flash[:error] = 'Error change task state'
    end
    redirect_to task_list_tasks_path
  end

  private

  def authorized_user
    @task_list = TaskList.find(params[:task_list_id]) if params[:task_list_id]
    @project = @task_list.project if @task_list.project

    return if (@project and @project.users.include?(current_user))
    return if (@task_list and @task_list.user_id == current_user.id)
    redirect_to access_url
  end

end
