require 'spec_helper'

describe Project do

  it "should create project with valid attributes" do
    lambda {
      FactoryGirl.create(:project)
    }.should change { Project.count }
  end

  it { should have_many(:task_lists) }

  it { should have_many(:relationships) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:name)}

  it "should have all users list through user_id and relationships" do
    user_directly = User.create!(email: 'first@mail.com', password: 'password', password_confirmation: 'password')
    user_relation = User.create!(email: 'second@mail.com', password: 'password', password_confirmation: 'password')
    project = Project.create!(name: 'Project name', user_id: user_directly.id)
    Relationship.create!(project_id: project.id, user_id: user_relation.id)
    project.users.should == [user_relation, user_directly]
  end


end