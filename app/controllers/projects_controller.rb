class ProjectsController < ApplicationController
  before_filter :authorized_user, except: [:index, :create, :new]
  def index
    @projects_item = current_user.projects.order("id DESC")
    @relationship = Relationship.where("follower_id = ?", current_user.id)
    @projects_follower_item = @relationship.map{ |relation| Project.find_by_id(relation.project_id)}
    @task_lists_item = current_user.task_lists.where("project_id IS NULL")
    @title = "All projects"
  end

  def show
    @project = Project.find(params[:id])
    @title = @project.name
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render action: edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  def peoples
    @project = Project.find(params[:id])
    @owner = @project.user
    @relationship = Relationship.where("project_id = ?", @project.id)
    @peoples = @relationship.map{ |relation| User.find_by_id(relation.follower_id)}
  end

  def invite
    if !params[:email].nil? and !params[:id].nil?
      @invited_user = User.find_by_email(params[:email])
      @project = Project.find(params[:id])
      redirect_to invite_project_url(@project), notice: 'No such user.' if @invited_user.nil?
      if !@project.nil? and !@invited_user.nil?
        @relationship = Relationship.new
        @relationship.followed_id = current_user.id
        @relationship.follower_id = @invited_user.id
        @relationship.project_id = @project.id
        if @relationship.save
          Mailer.invite(@invited_user, @project.name).deliver
          redirect_to invite_project_url(@project), notice: 'User was successfully added to project.'
        else
          edirect_to invite_project_url(@project), notice: 'Error add user to project.'
        end
      end
    end

  end

  def rempeople
    @user = User.find_by_id(params[:id])
    @project = Project.find(params[:project_id])
    @relationship = Relationship.where("project_id = ? and follower_id= ?", @project.id, @user.id)
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
      @relationship = Relationship.where("project_id = ? and follower_id = ?", @project.id, current_user.id)
      @follower = @relationship.first if !@relationship.nil?
      if @follower.nil?
        redirect_to access_url
      elsif current_user.id != @follower.follower_id
        redirect_to access_url
      end
    end
  end

end
