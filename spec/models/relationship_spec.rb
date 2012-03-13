require 'spec_helper'

describe Relationship do
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it "should have user and project" do
    should validate_presence_of(:user_id)
    should validate_presence_of(:project_id)
  end

  it "should have uniqueness project and user" do
    Relationship.create! :user_id => 1, :project_id => 2
    duplicate_record = Relationship.new user_id: 1, project_id: 2
    duplicate_record.should_not be_valid
  end

end