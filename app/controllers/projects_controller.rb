class ProjectsController < ApplicationController
   def index
     @user = User.find(params[:user_id])
     @projects = @user.projects.order("id DESC")
     @title = "All projects"
  end

  def show
    @user = User.find(params[:user_id])
    @project = @user.projects.find(params[:id])
    @title = @project.name
  end

  def new
    @user = User.find(params[:user_id])
    @project = @user.projects.new
  end

  def edit
    @user = User.find(params[:user_id])
    @project = @user.projects.find(params[:id])
  end

  def create
    @user = User.find(params[:user_id])
    @project = Project.new(params[:project])
    @project.user_id = @user.id
    if @project.save
      redirect_to [@user, @project], notice: 'Project was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:user_id])
    @project = @user.projects.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to [@user, @project], notice: 'Project was successfully updated.'
    else
      render action: edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @project = @user.projects.find(params[:id])
    @project.destroy

    redirect_to user_projects_path
  end

end
