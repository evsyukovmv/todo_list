require 'spec_helper'

describe "routing to matches" do

  it "routes / to pages#home" do
    { get: '/' }.should route_to(
      controller: 'pages',
      action: 'home'
    )
  end


  it "routes /access to pages#access" do
    { get: '/access' }.should route_to(
      controller: 'pages',
      action: 'access'
    )
  end

  it "routes /task_lists/1/tasks/done to tasks#index for state done" do
    { get: '/task_lists/1/tasks/done' }.should route_to(
      controller: 'tasks',
      action: 'index',
      task_list_id: '1',
      state: 'done'
    )
  end

  it "routes /task_lists/1/tasks/in_process to tasks#index for state in process" do
    { get: '/task_lists/1/tasks/in_process' }.should route_to(
      controller: 'tasks',
      action: 'index',
      task_list_id: '1',
      state: 'in_process'
    )
  end

  it "routes /task_lists/1/tasks/not_done to tasks#index for state not done" do
    { get: '/task_lists/1/tasks/not_done' }.should route_to(
      controller: 'tasks',
      action: 'index',
      task_list_id: '1',
      state: 'not_done'
    )
  end

  it "routes /projects/1/remove_user/2 to projects#remove_user for project id and user id" do
    { get: '/projects/1/remove_user/2' }.should route_to(
      controller: 'projects',
      action: 'remove_user',
      id: '1',
      user_id: '2'
    )
  end

end