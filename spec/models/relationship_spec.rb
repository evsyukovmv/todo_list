require 'spec_helper'

describe Relationship do

  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:project_id) }

  it "should have uniqueness project and user" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    Relationship.create! user_id: user.id, project_id: project.id
    duplicate_record = Relationship.new user_id: user.id, project_id: project.id
    duplicate_record.should_not be_valid
  end

  it "should receive mailer for notify invited user" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    relationship = Relationship.new user_id: user.id, project_id: project.id
    Mailer.stub_chain(:invite, :deliver)
    Mailer.should_receive(:invite).with(user, project.name)
    relationship.save
  end


end