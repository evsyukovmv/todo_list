class TaskListsController < ApplicationController
   def index
     @user = User.find(params[:user_id])
     @task_lists = @user.task_lists.order("id DESC")
     @title = "All task lists"
  end

  def show
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.find(params[:id])
    @title = @task_list.name
  end

  def new
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.new
  end

  def edit
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.find(params[:id])
  end

  def create
    @user = User.find(params[:user_id])
    @task_list = TaskList.new(params[:task_list])
    @task_list.user_id = @user.id
    if @task_list.save
      redirect_to [@user, @task_list], notice: 'Task list was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.find(params[:id])
    if @task_list.update_attributes(params[:task_list])
      redirect_to @task_list, notiece: 'Task list was successfully updated.'
    else
      render action: edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @task_list = @user.task_lists.find(params[:id])
    @task_list.destroy

    redirect_to user_task_lists_path
  end

end
