class ProjectsController < ApplicationController

  load_and_authorize_resource

  def index
    @projects = current_user.projects
  end

  def show

  end

  def new

  end

  def edit

  end

  def create
    if @project.save
      flash[:success] =  'Project was successfully created'
      redirect_to @project
    else
      flash[:error] =  'Project create error'
      render 'new'
    end
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:success] = 'Project was successful updated'
      redirect_to @project
    else
      flash[:error] = 'Project update error'
      render 'edit'
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = 'Project '+@project.name+' was successfully destroyed'
    else
      flash[:error] = 'Project destroy error'
    end
    redirect_to projects_path
  end

end