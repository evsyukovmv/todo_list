def valid_task
  @task ||= {name: "my_task_name", description: "my task description"}
end

def valid_update_task
  @task ||= {name: "my_another_task_name", description: "my another task description"}
end

def create_task task
  find('.menu').find('.dropdown-toggle').click
  click_link('Task')
  fill_in "name", with: task[:name]
  fill_in "description", with: task[:description]
  click_button "Create task"
end

def update_task task
  click_link 'edit'
  fill_in "name", with: task[:name]
  fill_in "description", with: task[:description]
  click_button "Update task"
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
end

When /^I create task with invalid data in task list$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  task = valid_task.merge(name: "")
  create_task task
end

Then /^I see an invalid create task messages in task list$/ do
  page.should have_selector(:xpath, "//input[@type='text' and @name='name']")
  page.should have_selector(:xpath, "//textarea[@name='description']")
  page.should have_selector(:xpath, "//input[@type='submit' and @value='Create task']")
end

When /^I destroy task$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  find('.operations').click_link('destroy')
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
    page.should have_content('in process')
  end
end

Then /^I see task is done$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  within('.operations') do
    page.should have_content('done')
  end
end

Then /^I see task id not done$/ do
  visit root_path
  find('#task_list').click_link('Tasks')
  within('.operations') do
    page.should have_content('not done')
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
  page.should have_selector(:xpath, "//input[@type='text' and @name='name']")
  page.should have_selector(:xpath, "//textarea[@name='description']")
  page.should have_selector(:xpath, "//input[@type='submit' and @value='Update task']")
end