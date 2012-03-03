#User
def valid_user
  @user ||= { :name => "Test User", :email => "test@example.com",
              :password => "password", :password_confirmation => "password"}
end

def valid_other_user
  @user ||= { :name => "Test Other User", :email => "test_other@example.com",
              :password => "password", :password_confirmation => "password"}
end

def sign_up user
  visit '/signup'
  fill_in "Name", :with => user[:name]
  fill_in "Email", :with => user[:email]
  fill_in "Password", :with => user[:password]
  fill_in "Confirmation", :with => user[:password_confirmation]
  click_button "Sign up"
end

def sign_in user
  visit '/signin'
  fill_in "Email", :with => user[:email]
  fill_in "Password", :with => user[:password]
  click_button "Sign in"
end

#Project
def valid_project
  @project ||= {name: "my project", description: "my project description"}
end

def create_project project
  click_link 'New project'
  fill_in "Name", with: project[:name]
  fill_in "Description", with: project[:description]
  click_button "Create Project"
end

#Task list

def valid_task_list
  @task_list ||= {name: "my task list", description: "my task list description"}
end

def create_task_list task_list
  click_link 'New task list'
  fill_in "Name", with: task_list[:name]
  fill_in "Description", with: task_list[:description]
  click_button "Create Task list"
end

#Task

def valid_task
  @task ||= {name: "my_task_name", description: "my task description"}
end

def valid_update_task
  @task ||= {name: "my_another_task_name", description: "my another task description"}
end

def create_task task
  click_link 'New task'
  fill_in "Name", with: task[:name]
  fill_in "Description", with: task[:description]
  click_button "Create Task"
end

def update_task task
  click_link 'Edit'
  fill_in "Name", with: task[:name]
  fill_in "Description", with: task[:description]
  click_button "Update Task"
end