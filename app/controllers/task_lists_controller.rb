class TaskListsController < ApplicationController
  before_filter :authorized_user, except: [:index, :create, :new]
  def index
    @title = "All task lists"

    if !params[:project_id].nil?
      :authorized_user
      @project = Project.find(params[:project_id])
      @task_lists = @project.task_lists
      @title += ' - project '+@project.name
    else
      @task_lists = current_user.task_lists.where('project_id IS NULL')
    end

  end

  def show
    @title = ""
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
      @title = @project.name+' - '
    else
      @task_list = TaskList.find(params[:id])
    end
    @title += @task_list.name
  end

  def new
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.new
    else
      @task_list = TaskList.new
    end
  end

  def edit
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
    else
      @task_list = TaskList.find(params[:id])
    end
  end

  def create
    @task_list = TaskList.new(params[:task_list])
    @task_list.user_id = current_user.id
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list.project_id = @project.id
    end

    if @task_list.save
      @project.nil? ? redirect_to(task_lists_path) : redirect_to(project_task_lists_path)
    else
      render action: "new"
    end
  end

  def update
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
    else
      @task_list = TaskList.find(params[:id])
    end
    if @task_list.update_attributes(params[:task_list])
      redirect_to [@project, @task_list], notiece: 'Task list was successfully updated.'
    else
      render(action: edit)
    end
  end

  def destroy
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:id])
    else
      @task_list = TaskList.find(params[:id])
    end
    @task_list.destroy
    @project.nil?? redirect_to(task_lists_path) : redirect_to(project_task_lists_path)
  end

  private

  def authorized_user
    @task_list = TaskList.find(params[:id])
    if !@task_list.user_id.nil?
      @project = @task_list.project
      if !@project.nil?
        if @project.user_id != current_user.id
          @relationship = Relationship.where("project_id = ? and follower_id = ?", @project.id, current_user.id)
          @follower = @relationship.first if !@relationship.nil?
          if @follower.nil?
            redirect_to access_url
          elsif current_user.id != @follower.follower_id
            redirect_to access_url
          end
        end
      elsif @task_list.user_id != current_user.id
        redirect_to access_url
      end
    else
      redirect_to access_url
    end
  end

end
