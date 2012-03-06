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
  task = valid_update_task.merge(name: "")
  update_task task
end

Then /^I see an invalid update task messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I create task with valid data assign to other user in task list in project$/ do
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  user_other = valid_other_user
  task = valid_task
  find('.menu').find('.dropdown-toggle').click
  click_link('Task')
  fill_in "Name", with: task[:name]
  fill_in "Description", with: task[:description]
  select user_other[:name], from: 'Performer'
  click_button "Create Task"
end

Then /^I see successful created task assigned to other in task list in project$/ do
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  task = valid_task
  user_other = valid_other_user
  page.should have_content task[:name]
  page.should have_content task[:description]
  page.should have_content user_other[:name]
end

When /^I update task with valid data assign to other user in task list in project$/ do
  user = valid_user
  task = valid_task
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  click_link 'Edit'
  fill_in "Name", with: task[:name]
  fill_in "Description", with: task[:description]
  select user[:name], from: 'Performer'
  click_button "Update Task"
end

Then /^I see successful updated task assigned to other in task list in project$/ do
  task = valid_task
  user = valid_user
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  page.should have_content task[:name]
  page.should have_content task[:description]
  page.should have_content user[:name]
end
