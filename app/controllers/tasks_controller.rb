class TasksController < ApplicationController
  before_filter :authorized_user
  def index
    if !params[:project_id].nil?
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:task_list_id])
    else
      @task_list = TaskList.find(params[:task_list_id])
    end

    if params[:state] == 'done'
      @tasks = @task_list.task.where("state = 'Done'").order "id DESC"
    elsif params[:state] == 'inprocess'
      @tasks = @task_list.task.where("state = 'In process'").order "id DESC"
    elsif params[:state] == 'notdone'
      @tasks = @task_list.task.where("state = 'Not done'").order "id DESC"
    else
      @tasks = @task_list.task.order "id DESC"
    end
    @title = "All tasks"
 end

 def show
   if !params[:project_id].nil?
     @project = Project.find(params[:project_id])
     @task_list = @project.task_lists.find(params[:task_list_id])
   else
     @task_list = TaskList.find(params[:task_list_id])
   end

   @task = @task_list.task.find(params[:id])
   @title = @task.name
 end

 def new
     @task_list = TaskList.find(params[:task_list_id])
     @project = @task_list.project
     if !@project.nil?
       @relationship = Relationship.where("project_id = ?", @project.id)
       @performers = @relationship.map{ |relation| User.find_by_id(relation.follower_id)}
       @performers.unshift(@project.user)
     end

   @task = @task_list.task.new
 end

 def edit
   if !params[:project_id].nil?
     @project = Project.find(params[:project_id])
     @task_list = @project.task_lists.find(params[:task_list_id])
   else
     @task_list = TaskList.find(params[:task_list_id])
   end

   @task = @task_list.task.find(params[:id])
 end

 def create
   @task = Task.new(params[:task])
   @task.task_list_id= @task_list.id
   @project = @task.task_list.project if !@task.task_list.project.nil?
   Mailer.changed(@task.user, @project.name, @task.name).deliver if !@task.performer_id.nil?
   if @task.save
     redirect_to [@task_list, @task], notice: 'Task was successfully created.'
   else
     render action: "new"
   end
 end

 def update
   if !params[:project_id].nil?
     @project = Project.find(params[:project_id])
     @task_list = @project.task_lists.find(params[:task_list_id])
   else
     @task_list = TaskList.find(params[:task_list_id])
   end

   @task = @task_list.task.find(params[:id])
   if @task.update_attributes(params[:task])
     redirect_to [@task_list, @task], notiece: 'Task was successfully updated.'
   else
     render action: edit
   end
 end

 def destroy
   if !params[:project_id].nil?
     @project = Project.find(params[:project_id])
     @task_list = @project.task_lists.find(params[:task_list_id])
   else
     @task_list = TaskList.find(params[:task_list_id])
   end

   @task = @task_list.task.find(params[:id])
   @task.destroy

   @project.nil?? redirect_to(task_list_tasks_path) : redirect_to(task_list_tasks_path)

 end

  def change_state

    @task_list = TaskList.find(params[:task_list_id])
    @task = @task_list.task.find(params[:id])
    if !@task_list.project.nil?
      @project = @task_list.project
    end

    if @task.state == :"Not done"
      @task.state = :"In process"
    elsif @task.state == :"In process"
      @task.state = :"Done"
    else
      @task.state = :"Not done"
    end

    if @task.save
      if !@project.nil? and !@task.performer_id.nil?
        Mailer.changed(@task.user, @project.name, @task.name).deliver
      end
      redirect_to task_list_tasks_path, notice: 'Task state was successfully updated.'
    else
      if !@project.nil?
        render task_list_tasks_path
      else
        render task_list_tasks_path
      end
    end

  end

  private

  def authorized_user
    @task_list = TaskList.find(params[:task_list_id])
    if !params[:id].nil?
      @task = Task.find(params[:id])
      if @task.task_list != @task_list
        redirect_to access_url
      end
    elsif !@task_list.user_id.nil?
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
