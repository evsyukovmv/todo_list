When /^I create project with valid data$/ do
  create_project valid_project
end

Then /^I see successful create project message$/ do
  project = valid_project
  page.should have_content project[:name]
  page.should have_content project[:description]
end

When /^I create project with invalid data$/ do
  project = valid_project.merge(name: "")
  create_project project
end

Then /^I see an invalid create project messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I update project with valid data$/ do
  project = valid_other_project
  update_project project
end

Then /^I see successful update project message$/ do
  project = valid_other_project
  page.should have_content project[:name]
  page.should have_content project[:description]
end

When /^I update project with invalid data$/ do
  project = valid_project.merge(name: "")
  update_project project
end

Then /^I see an invalid update project messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I destroy project$/ do
  visit root_path
  page.evaluate_script('window.confirm = function() { return true; }')
  find('#project').click_link('Destroy')
end

Then /^I see successful destroy project message$/ do
  visit root_path
  project = valid_project
  page.should_not have_content project[:name]
  page.should_not have_content project[:description]
end

When /^I create and invite other user to project$/ do
  user = valid_user
  user_other = valid_other_user
  step 'I am not logged in'
  sign_up user_other
  step 'I am not logged in'
  sign_in user
  invite_user user_other
end

Then /^I see invited user in project$/ do
  user = valid_user
  user_other = valid_other_user
  page.should have_content 'User was successfully added to project.'
  step 'I am not logged in'
  sign_in user
  find('#project').click_link('Peoples')
  find('.table-striped').should have_content user_other[:name]
  find('.table-striped').should have_content user_other[:email]
end

Then /^Other user can see my project$/ do
  user_other = valid_other_user
  project = valid_project
  step 'I am not logged in'
  sign_in user_other
  page.should have_content project[:name]
  page.should have_content project[:description]
end

When /^I remove user from project$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
  click_link('Destroy')
end

Then /^I do not see removed invited user in project$/ do
  user_other = valid_other_user
  find('.table-striped').should_not have_content user_other[:name]
  find('.table-striped').should_not have_content user_other[:email]
end
