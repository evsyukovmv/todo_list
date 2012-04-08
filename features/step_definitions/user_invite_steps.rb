def create_visitor_other
  @visitor_other ||= { :email => "user_other@example.com",
                 :password => "please", :password_confirmation => "please" }
end

def delete_user_other
  @user_other ||= User.first conditions: {:email => @visitor_other[:email]}
  @user_other.destroy unless @user_other.nil?
end

def create_user_other
  create_visitor_other
  delete_user_other
  @user_other = FactoryGirl.create(:user, email: @visitor_other[:email])
end

def sign_in_other
  visit '/users/sign_in'
  fill_in "Email", :with => @visitor_other[:email]
  fill_in "Password", :with => @visitor_other[:password]
  click_button "Sign in"
end

Given /^Exist other user$/ do
  create_user_other
end

When /^I invite other user to project$/ do
  visit root_path
  find('#project').click_link('Users')
  click_link 'Invite'
  fill_in 'email', with: @user_other[:email]
  click_button 'Invite to project'
end

Then /^I see invited user in project$/ do
  page.should have_content 'User was successfully added to project'
  visit root_path
  find('#project').click_link('Users')
  find('.table-striped').should have_content @user_other[:email]
end

When /^Invited user open projects$/ do
  step 'I am not logged in'
  sign_in_other
end

Then /^Invited user can see my project$/ do
  project = valid_project
  page.should have_content project[:name]
  page.should have_content project[:description]
end


When /^I remove user from project$/ do
  visit root_path
  find('#project').click_link('Users')
  page.evaluate_script('window.confirm = function() { return true; }')
  click_link('Destroy')
end

Then /^I can't see other user in project$/ do
  find('.table-striped').should_not have_content @user_other[:email]
end