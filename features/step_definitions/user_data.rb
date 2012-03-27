#Project


def invite_user user
  find('#project').click_link('Peoples')
  click_link 'Invite'
  fill_in 'email', with: user[:email]
  click_button 'Invite to project'
end

#Task list

def valid_task_list
  @task_list ||= {name: "my task list", description: "my task list description"}
end

def valid_other_task_list
  @task_list ||= {name: "my other task list", description: "my other task list description"}
end

def create_task_list task_list
  find('.menu').find('.dropdown-toggle').click
  click_link('Task list')
  fill_in "Name", with: task_list[:name]
  fill_in "Description", with: task_list[:description]
  click_button "Create Task list"
end

def update_task_list task_list
  find('#task_list').click_link('Edit')
  fill_in "Name", with: task_list[:name]
  fill_in "Description", with: task_list[:description]
  click_button "Update Task list"
end

#Task

def valid_task
  @task ||= {name: "my_task_name", description: "my task description"}
end

def valid_update_task
  @task ||= {name: "my_another_task_name", description: "my another task description"}
end

def create_task task
  find('.menu').find('.dropdown-toggle').click
  click_link('Task')
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