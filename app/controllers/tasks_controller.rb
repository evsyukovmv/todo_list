class TasksController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.find(params[:task_list_id])

    if params[:state] == 'done'
      @tasks = @task_list.task.where("state = 'Done'").order "id DESC"
    elsif params[:state] == 'inprocess'
      @tasks = @task_list.task.where("state = 'In process'").order "id DESC"
    elsif params[:state] == 'notdone'
      @tasks = @task_list.task.where("state = 'Not done'").order "id DESC"
    else
      @tasks = @task_list.task.order "id DESC"
    end

    @title = "All tasks"
 end

 def show
   @user = User.find(params[:user_id])
   @task_list = @user.task_lists.find(params[:task_list_id])

   @task = @task_list.task.find(params[:id])
   @title = @task.name
 end

 def new
   @user = User.find(params[:user_id])
   @task_list = @user.task_lists.find(params[:task_list_id])
   @task = @task_list.task.new
 end

 def edit
   @user = User.find(params[:user_id])
   @task_list = @user.task_lists.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
 end

 def create
   @user = User.find(params[:user_id])
   @task_list = @user.task_lists.find(params[:task_list_id])
   @task = Task.new(params[:task])
   @task.task_list_id= @task_list.id

   if @task.save
     redirect_to [@user, @task_list, @task], notice: 'Task was successfully created.'
   else
     render action: "new"
   end
 end

 def update
   @user = User.find(params[:user_id])
   @task_list = @user.task_lists.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
   if @task.update_attributes(params[:task])
     redirect_to [@user, @task_list, @task], notiece: 'Task was successfully updated.'
   else
     render action: edit
   end
 end

 def destroy
   @user = User.find(params[:user_id])
   @task_list = @user.task_lists.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
   @task.destroy
   redirect_to user_task_list_tasks_path
 end

  def change_state
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.find(params[:task_list_id])
    @task = @task_list.task.find(params[:id])
    if @task.state == :"Not done"
      @task.state = :"In process"
    elsif @task.state == :"In process"
      @task.state = :"Done"
    else
      @task.state = :"Not done"
    end

    if @task.save
      redirect_to user_task_list_tasks_path, notice: 'Task state was successfully updated.'
    else
      render user_task_list_tasks_path
    end

  end

end
