require 'spec_helper'

describe User do
  it "should create task with valid attributes" do
    lambda {
      FactoryGirl.create(:user)
    }.should change { User.count }
  end

  it { should have_many :task_lists }
  it { should have_many :projects }
  it { should have_many :tasks }
  it { should have_many :relationships }

  it "should have all projects through user_id and relationships" do
    user = FactoryGirl.create(:user)
    project_directly = FactoryGirl.create(:project, user_id: user.id)
    project_relation = FactoryGirl.create(:project)
    Relationship.create!(project_id: project_relation.id, user_id: user.id)
    user.projects.should == [project_relation, project_directly]
  end

end