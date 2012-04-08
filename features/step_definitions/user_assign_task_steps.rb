
Given /^I have task list in project with invited user$/ do
  project = valid_project
  task_list = valid_task_list

  project_user = FactoryGirl.create(:project, name: project[:name], description: project[:description], user_id: @user.id)
  FactoryGirl.create(:task_list, name: task_list[:name], user_id: @user.id, project_id: project_user.id )
  Relationship.create!(project_id: project, user_id: @user_other.id)
end

When /^I create task with valid data assign to other user$/ do
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  task = valid_task
  find('.menu').find('.dropdown-toggle').click
  click_link('Task')
  fill_in "Name", with: task[:name]
  fill_in "Description", with: task[:description]
  select @user_other[:email], from: 'Performer'
  click_button "Create Task"
end

Then /^I see successful created task assigned to other user$/ do
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  task = valid_task
  page.should have_content task[:name]
  page.should have_content task[:description]
  page.should have_content @user_other[:email]
end

When /^I update task with valid data assign to self$/ do
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  click_link 'Edit'
  select @user[:email], from: 'Performer'
  click_button "Update Task"
end

Then /^I see successful updated task assigned to self$/ do
  task = valid_task
  visit root_path
  find('#project').click_link('Tasks lists')
  find('#task_list').click_link('Tasks')
  page.should have_content task[:name]
  page.should have_content task[:description]
  page.should have_content @user[:email]
end