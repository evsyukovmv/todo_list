class TaskListsController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :task_list, :through => :project, :shallow => true

  def index
    if @project
      @task_lists = @project.task_lists
    else
      @task_lists = current_user.task_lists.where('project_id IS NULL')
    end
  end

  def show

  end

  def new

  end

  def edit

  end

  def create
    respond_to do |format|
      if @task_list.save
        format.html { redirect_to @task_list, success: 'Task list was successfully created' }
        format.json { render json: @task_list, status: :created, location: @task_list }
      else
        format.html { render action: "new" }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task_list.update_attributes(params[:task_list])
        format.html { redirect_to @task_list, success: 'Task list was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @task_list.destroy
      flash[:success] = 'Task list '+@task_list.name+' was successfully destroyed'
    else
      flash[:error] = 'Error task list destroy'
    end
    @project? redirect_to(project_task_lists_path): redirect_to(task_lists_path)
  end
end
