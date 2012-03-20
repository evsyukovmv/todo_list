class ProjectsController < ApplicationController

  def index
    @projects = current_user.projects
    @title = "All projects"
  end

  def show
    @project = Project.find params[:id]
    @title = @project.name
  end

  def new
    @project = Project.new
    @title = 'New project'
  end

  def edit
    @project = Project.find params[:id]
    @title = 'Edit project '+@project.name
  end

  def create
    @project = Project.new(params[:project])
    @project.user = current_user
    if @project.save
      flash[:success] =  'Project was successfully created'
      redirect_to @project
    else
      flash[:error] =  'Project create error'
      render 'new'
    end
  end

  def update
    @project = Project.new params[:id]
    if @project.update_attributes(params[:project])
      flash[:success] = 'Project was successful updated'
      redirect_to @project
    else
      flash[:error] = 'Project update error'
      render 'edit'
    end
  end

  def destroy
    @project = Project.find params[:id]
    if @project.destroy
      flash[:success] = 'Project '+@project.name+' was successfully destroyed'
    else
      flash[:error] = 'Project destroy error'
    end
    redirect_to projects_path
  end

  def users
    @project = Project.find params[:id]
    @peoples = @project.users
    @owner = @peoples.pop
    @title = "Users of "+@project.name
  end

  def add_user
    @project = Project.find params[:id]
    @invited_user = User.find_by_email(params[:email]) if params[:email]

    if @invited_user.nil?
      flash[:error] = 'Error. No such user'
      return redirect_to invite_project_url(@project)
    end

    if @project.nil?
      flash[:error] = 'Error. No such project'
      return redirect_to projects_url
    end

    @relationship = Relationship.new(user_id: @invited_user.id, project_id: @project.id)

    if @relationship.save
      Mailer.invite(@invited_user, @project.name).deliver
      flash[:success] = 'User was successfully added to project'
      redirect_to invite_project_url(@project)
    else
      flash[:error] = 'Error add user to project'
      redirect_to invite_project_url(@project)
    end
  end

  def invite
    @project = Project.find params[:id]
    @title = "Invite to "+@project.name
  end

  def remove_user
    @project = Project.find params[:id]
    @user = User.find_by_id(params[:user_id])
    if @project.relationships.find_by_user_id(@user.id).destroy
      flash[:success] = 'User '+@user.name+' was successfully removed from project '+@project.name
    else
      flash[:error] = 'Error user destroy from project '+@project.name
    end
    redirect_to users_project_path(@project)
  end

end