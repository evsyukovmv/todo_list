class ProjectsController < ApplicationController

  before_filter :authorized_user, except: [:index, :create, :new]

  def index
    @projects_item = current_user.projects
    @title = "All projects"
  end

  def show
    @project = Project.find(params[:id])
    @title = @project.name
  end

  def new
    @project = Project.new
    @title = 'New project'
  end

  def edit
    @project = Project.find(params[:id])
    @title = 'Edit project '+@project.name
  end

  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id
    if @project.save
      flash[:success] =  'Project was successfully created.'
      redirect_to @project
    else
      render action: "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:success] = 'Project was successfully updated.'
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:success] = 'Project was successfully destroyed.'
    redirect_to projects_path
  end

  def peoples
    @project = Project.find(params[:id])
    @owner = @project.user
    @relationship = Relationship.where("project_id = ?", @project.id)
    @peoples = @relationship.map{ |relation| User.find_by_id(relation.user_id)}
    @title = "Peoples of "+@project.name
  end

  def invite
    if params[:email] and params[:id]
      @invited_user = User.find_by_email(params[:email])
      @project = Project.find(params[:id])
      if @invited_user.nil?
        flash[:error] = 'No such user.'
        redirect_to invite_project_url(@project)
      end

      if @project and @invited_user
        @relationship = Relationship.new(user_id: @invited_user.id, project_id: @project.id)
        if @relationship.save
          Mailer.invite(@invited_user, @project.name).deliver
          flash[:success] = 'User was successfully added to project.'
          redirect_to invite_project_url(@project)
        else
          flash[:error] = 'Error add user to project.'
          redirect_to invite_project_url(@project)
        end
      end
    else
      flash[:error] = 'Expected user and project.'
    end
  end

  def rempeople
    @user = User.find_by_id(params[:id])
    @project = Project.find(params[:project_id])
    @relationship = Relationship.where("project_id = ? and user_id= ?", @project.id, @user.id)
    @relationship.first.destroy

    redirect_to peoples_project_path(@project)
  end

  private

  def authorized_user
    @project = Project.find_by_id(params[:id])
    @project = Project.find(params[:project_id]) if !params[:project_id].nil?
    if @project.nil?
      redirect_to access_url
    elsif @project.user_id != current_user.id
      @relationship = Relationship.where("project_id = ? and user_id = ?", @project.id, current_user.id)
      @follower = @relationship.first if !@relationship.nil?
      if @follower.nil?
        redirect_to access_url
      elsif current_user.id != @follower.follower_id
        redirect_to access_url
      end
    end
  end

end
