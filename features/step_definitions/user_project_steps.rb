### UTILITY METHODS ###

def valid_project
  @project ||= {name: "my project", description: "my project description"}
end

def valid_other_project
  @project ||= {name: "my other project", description: "my other project description"}
end

def create_project project
  visit root_path
  find('.menu').find('.dropdown-toggle').click
  click_link('Project')
  fill_in "Name", with: project[:name]
  fill_in "Description", with: project[:description]
  click_button "Create Project"
end

def update_project project
  visit root_path
  find('#project').click_link('Edit')
  fill_in "Name", with: project[:name]
  fill_in "Description", with: project[:description]
  click_button "Update Project"
end

### GIVEN ###

Given /^I exist as a user and signed in$/ do
  step 'I sign up with valid user data'
  step 'I should be signed in'
end

Given /^I have project$/ do
  project = valid_project
  FactoryGirl.create(:project, name: project[:name], user_id: @user.id)
end

### WHEN ###

When /^I create project with valid data$/ do
  create_project valid_project
end

When /^I create project with invalid data$/ do
  project = valid_project.merge(name: "")
  create_project project
end


When /^I update project with valid data$/ do
  project = valid_other_project
  update_project project
end

When /^I update project with invalid data$/ do
  project = valid_project.merge(name: "")
  update_project project
end

When /^I destroy project$/ do
  visit root_path
  page.evaluate_script('window.confirm = function() { return true; }')
  find('#project').click_link('Destroy')
end

### THEN ###

Then /^I see successful create project message$/ do
  project = valid_project
  page.should have_content 'Project was successfully created'
  page.should have_content project[:name]
  page.should have_content project[:description]
end

Then /^I see an invalid create project messages$/ do
  page.should have_content "Name can't be blank"
end

Then /^I see successful update project message$/ do
  project = valid_other_project
  page.should have_content 'Project was successful updated'
  page.should have_content project[:name]
  page.should have_content project[:description]
end

Then /^I see an invalid update project messages$/ do
  page.should have_content "Name can't be blank"
end

Then /^I see successful destroy project message$/ do
  project = valid_project
  page.should have_content 'Project '+project[:name]+' was successfully destroyed'
  visit root_path
  page.should_not have_content project[:name]
  page.should_not have_content project[:description]
end
