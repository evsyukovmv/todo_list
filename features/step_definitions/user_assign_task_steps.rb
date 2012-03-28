
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
  select user_other[:email], from: 'Performer'
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
  page.should have_content user_other[:email]
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
  select user[:email], from: 'Performer'
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
  page.should have_content user[:email]
end