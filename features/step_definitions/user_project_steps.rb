When /^I create project with valid data$/ do
  visit root_path
  create_project valid_project
end

Then /^I see successful create project message$/ do
  page.should have_content "my project"
  page.should have_content "my project description"
end

When /^I create project with invalid data$/ do
  visit root_path
  project = valid_project.merge(name: "")
  create_project project
end

Then /^I see an invalid create project messages$/ do
  page.should have_content "Name can't be blank"
end

When /^I update project with valid data$/ do
  visit root_path
  find('#project').click_link('Edit')
  fill_in "Name", with: "another_name"
  fill_in "Description", with: "another_description"
  click_button "Update Project"
end

Then /^I see successful update project message$/ do
  page.should have_content "another_name"
  page.should have_content "another_description"
end

When /^I update project with invalid data$/ do
  visit root_path
  find('#project').click_link('Edit')
  fill_in "Name", with: ""
  fill_in "Description", with: ""
  click_button "Update Project"
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
  page.should_not have_content "my project"
  page.should_not have_content "my project description"
end

When /^I create and invite other user to project$/ do
  visit '/signout'
  user = valid_user
  user_other = valid_other_user
  sign_up user_other
  visit '/signout'
  sign_in user
  find('#project').click_link('Peoples')
  click_link 'Invite'
  fill_in 'email', with: user_other[:email]
  click_button 'Invite to project'
end

Then /^I see invited user in project$/ do
  page.should have_content 'User was successfully added to project.'
  visit '/signout'
  user = valid_user
  user_other = valid_other_user
  sign_in user
  find('#project').click_link('Peoples')
  page.should have_content user_other[:name]
  page.should have_content user_other[:email]
end

Then /^Other user can see my project$/ do
  visit '/signout'
  user_other = valid_other_user
  sign_in user_other
  project = valid_project
  page.should have_content project[:name]
  page.should have_content project[:description]
end
