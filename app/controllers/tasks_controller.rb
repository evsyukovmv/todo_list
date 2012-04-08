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
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, success: 'Task was successfully created' }
        format.json { render json: @task, status: :created, location: [@task_list, @task] }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update_attributes(params[:project])
        format.html { redirect_to @project, success: 'Task was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to task_list_tasks_path(@task_list) }
      format.json { head :no_content }
    end
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
