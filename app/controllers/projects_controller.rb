class ProjectsController < ApplicationController

  load_and_authorize_resource

  def index
    @projects = current_user.projects
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
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
      if @project.save
        format.html { redirect_to @project, success: 'Project was successfully created' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, success: 'Project was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
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