class TasksController < ApplicationController
  def index
    @task_list = TaskList.find(params[:task_list_id])

    if params[:state] == 'done'
      @tasks = @task_list.task.where("state = 't'").order "id DESC"
    elsif params[:state] == 'inwork'
      @tasks = @task_list.task.where("state = 'f'").order "id DESC"
    else
      @tasks = @task_list.task.order "id DESC"
    end

    @title = "All tasks"
 end

 def show
   @task = Task.find(params[:id])
   @title = @task.name
 end

 def new
   @task_list = TaskList.find(params[:task_list_id])
   @task = @task_list.task.new
 end

 def edit
   @task_list = TaskList.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
 end

 def create

   @task_list = TaskList.find(params[:task_list_id])
   @task = Task.new(params[:task])
   @task.task_list_id= @task_list.id

   if @task.save
     redirect_to [@task_list, @task], notice: 'Task was successfully created.'
   else
     render action: "new"
   end
 end

 def update
   @task_list = TaskList.find(params[:task_list_id])
   @task = @task_list.task.find(params[:id])
   if @task.update_attributes(params[:task])
     redirect_to [@task_list, @task], notiece: 'Task was successfully updated.'
   else
     render action: edit
   end
 end

 def destroy
    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.task.find(params[:id])
    @task.destroy
    redirect_to task_list_tasks_path
 end

  def change_state
    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.task.find(params[:id])
    if @task.state == :"Not done"
      @task.state = :"In process"
    elsif @task.state == :"In process"
      @task.state = :"Done"
    else
      @task.state = :"Not done"
    end

    if @task.save
      redirect_to task_list_tasks_path, notice: 'Task state was successfully updated.'
    else
      render task_list_tasks_path
    end

  end

end
