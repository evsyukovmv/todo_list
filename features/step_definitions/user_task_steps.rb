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

Given /^I have task$/ do
  task = valid_task_list
  FactoryGirl.create(:task, name: task[:name], description: task[:description], task_list_id: @task_list_created.id)
end


When /^I create task with valid data in task list$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  create_task valid_task
end

Then /^I see successful create task message in task list$/ do
  task = valid_task
  page.should have_content task[:name]
  page.should have_content task[:description]
  page.should have_content "Task was successfully created"
end

When /^I create task with invalid data in task list$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  task = valid_task.merge(name: "")
  create_task task
end

Then /^I see an invalid create task messages in task list$/ do
  page.should have_content "Name can't be blank"
end

When /^I destroy task$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  page.evaluate_script('window.confirm = function() { return true; }')
  find('.operations').click_link('Destroy')
end

Then /^I see successful destroy task message$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  task = valid_task
  page.should_not have_content task[:name]
  page.should_not have_content task[:description]
end

When /^I change state of task$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  find('.operations').find('a', :href => /change_state/i).click
end

Then /^I see task is in process$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  within('.operations') do
    page.should have_content('In process')
  end
end

Then /^I see task is done$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  within('.operations') do
    page.should have_content('Done')
  end
end

Then /^I see task id not done$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  within('.operations') do
    page.should have_content('Not done')
  end
end

When /^I update task with valid data$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  task = valid_update_task
  update_task task
end

Then /^I see successful update task message$/ do
  task = valid_update_task
  page.should have_content task[:name]
  page.should have_content task[:description]
end

When /^I update task with invalid data$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  task = valid_update_task.merge(name: "")
  update_task task
end

Then /^I see an invalid update task messages$/ do
  page.should have_content "Name can't be blank"
end