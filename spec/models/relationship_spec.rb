require 'spec_helper'

describe Relationship do

  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:project_id) }

  it "should have uniqueness project and user" do
    Relationship.create! :user_id => 1, :project_id => 2
    duplicate_record = Relationship.new user_id: 1, project_id: 2
    duplicate_record.should_not be_valid
  end

end