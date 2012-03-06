When /^I create task list with valid data$/ do
  create_task_list valid_task_list
end

Then /^I see successful create task list message$/ do
  task_list = valid_task_list
  page.should have_content task_list[:name]
  page.should have_content task_list[:description]
end

When /^I create task list with invalid data$/ do
  visit root_path
  task_list = valid_task_list.merge(name: "")
  create_task_list task_list
end

Then /^I see an invalid create task list messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I update task list with valid data$/ do
  visit root_path
  task_list = valid_other_task_list.merge
  udpate_task_list task_list
end

Then /^I see successful update task list message$/ do
  task_list = valid_other_task_list
  page.should have_content task_list[:name]
  page.should have_content task_list[:description]
end

When /^I update task list with invalid data$/ do
  visit root_path
  task_list = valid_task_list.merge(name: "")
  update_task_list task_list
end

Then /^I see an invalid update task list messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I destroy task list$/ do
  visit root_path
  page.evaluate_script('window.confirm = function() { return true; }')
  find('#task_list').click_link('Destroy')
end

Then /^I see successful destroy task list message$/ do
  visit root_path
  task_list = valid_task_list
  page.should_not have_content task_list[:name]
  page.should_not have_content task_list[:description]
end


When /^I create task list with valid data in project$/ do
  visit root_path
  project = valid_project
  click_link project[:name]
  create_task_list valid_task_list
end

Then /^I see successful create task list message in project$/ do
  visit root_path
  project = valid_project
  task_list = valid_task_list
  click_link project[:name]
  page.should have_content task_list[:name]
  page.should have_content task_list[:description]
end
