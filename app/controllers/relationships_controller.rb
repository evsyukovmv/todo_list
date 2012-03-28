class RelationshipsController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :relationship, through: :project

  def index
    @relationships = @project.relationships
  end

  def new

  end

  def create
    @invited_user = User.find_by_email(params[:email]) if params[:email]

    if @invited_user.nil?
      flash[:error] = 'Error. No such user'
      return redirect_to new_project_user_path(@project)
    end

    @relationship.user_id = @invited_user

    if @relationship.save
      flash[:success] = 'User was successfully added to project'
      redirect_to new_project_user_path(@project)
    else
      flash[:error] = 'Error add user to project'
      redirect_to new_project_user_path(@project)
    end
  end

  def destroy
    if @relationship.destroy
      flash[:success] = 'User was successfully removed from project '+@project.name
    else
      flash[:error] = 'Error user destroy from project '+@project.name
    end
    redirect_to project_users_path(@project)
  end

end