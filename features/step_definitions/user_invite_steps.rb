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
  page.should have_content 'User was successfully added to project'
  visit root_path
  find('#project').click_link('Peoples')
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
  find('.table-striped').should_not have_content user_other[:email]
end