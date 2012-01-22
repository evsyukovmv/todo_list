class TaskListsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @title = "All task lists"

    if !params[:project_id].nil?
      @project = @user.projects.find(params[:project_id])
      @task_lists = @project.task_lists
      @title += ' - project '+@project.name
    else
      @task_lists = @user.task_lists.where('project_id IS NULL')
    end

  end

  def show
    @user = User.find(params[:user_id])
    @title = ""
    if !params[:project_id].nil?
      @project = @user.projects.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
      @title = @project.name+' - '
    else
      @task_list = @user.task_lists.find(params[:id])
    end
    @title += @task_list.name
  end

  def new
    @user = User.find(params[:user_id])
    if !params[:project_id].nil?
      @project = @user.projects.find(params[:project_id])
      @task_list = @project.task_lists.new
    else
      @task_list = @user.task_lists.new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    if !params[:project_id].nil?
      @project = @user.projects.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
    else
      @task_list = @user.task_lists.find(params[:id])
    end
  end

  def create
    @task_list = TaskList.new(params[:task_list])
    @user = User.find(params[:user_id])
    @task_list.user_id = @user.id
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list.project_id = @project.id
    end

    if @task_list.save
      redirect_to [@user, @project, @task_list], notice: 'Task list was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:user_id])
    if !params[:project_id].nil?
      @project = @user.projects.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
    else
      @task_list = @user.task_lists.find(params[:id])
    end
    if @task_list.update_attributes(params[:task_list])
      redirect_to [@user, @project, @task_list], notiece: 'Task list was successfully updated.'
    else
      render(action: edit)
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    if !params[:project_id].nil?
      @project = @user.projects.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
    else
      @task_list = @user.task_lists.find(params[:id])
    end
    @task_list.destroy
    @project.nil?? redirect_to(user_task_lists_path) : redirect_to(user_project_task_lists_path)
  end

end
