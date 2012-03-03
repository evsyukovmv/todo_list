When /^I create task list with valid data$/ do
  create_task_list valid_task_list
end

Then /^I see successful create task list message$/ do
  page.should have_content "my task list"
  page.should have_content "my task list description"
end

When /^I create task list with invalid data$/ do
  task_list = valid_task_list.merge(name: "")
  create_task_list task_list
end

Then /^I see an invalid create task list messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I update task list with valid data$/ do
  visit '/'
  find('#task_list').click_link('Edit')
  fill_in "Name", with: "another_name"
  fill_in "Description", with: "another_description"
  click_button "Update Task list"
end

Then /^I see successful update task list message$/ do
  page.should have_content "another_name"
  page.should have_content "another_description"
end

When /^I update task list with invalid data$/ do
  visit '/'
  find('#task_list').click_link('Edit')
  fill_in "Name", with: ""
  fill_in "Description", with: ""
  click_button "Update Task list"
end

Then /^I see an invalid update task list messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I destroy task list$/ do
  visit '/'
  page.evaluate_script('window.confirm = function() { return true; }')
  find('#task_list').click_link('Destroy')
end

Then /^I see successful destroy task list message$/ do
  visit '/'
  page.should_not have_content "my task list"
  page.should_not have_content "my task list description"
end


When /^I create task list with valid data in project$/ do
  visit '/'
  click_link 'my project'
  create_task_list valid_task_list
end

Then /^I see successful create task list message in project$/ do
  visit '/'
  click_link 'my project'
  page.should have_content "my task list"
  page.should have_content "my task list description"
end
