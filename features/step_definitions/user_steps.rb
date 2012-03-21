Given /^I am not logged in$/ do
  click_link 'Sign out'
end

When /^I sign up with valid user data$/ do
  sign_up valid_user
end

Then /^I should see user menu$/ do
  ["Home", "Projects", "Task lists", "Sign out"].each do |menu|
    page.should have_content menu
  end
end

When /^I sign up with an invalid email$/ do
  user = valid_user.merge(:email => "notanemail")
  sign_up user
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Sign up"
end

When /^I sign up without a email$/ do
  user = valid_user.merge(:email => "")
  sign_up user
end

Then /^I should see a missing email message$/ do
  page.should have_content "Email can't be blank"
end


When /^I sign up without a password$/ do
  user = valid_user.merge(:password => "")
  sign_up user
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

When /^I sign up without a confirmed password$/ do
  user = valid_user.merge(:password_confirmation => "")
  sign_up user
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

When /^I sign up with a mismatched password confirmation$/ do
  user = valid_user.merge(:password_confirmation => "wrong")
  sign_up user
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Given /^I exist as a user$/ do
  sign_up valid_user
end

When /^I sign in with valid user data$/ do
  sign_in valid_user
end

Given /^I do not exist as a user$/ do
  User.find(:first, conditions: {email: valid_user[:email]}).should be_nil
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password"
end

Then /^I should be sign out$/ do
  page.should have_content "Sign up"
  page.should have_content "Sign in"
  page.should_not have_content "Logout"
end

When /^I return to the site$/ do
  visit '/'
end



