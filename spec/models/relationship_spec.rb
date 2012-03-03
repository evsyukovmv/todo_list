require 'spec_helper'

describe Relationship do
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it "should have user and project" do
    [:user_id, :project_id].each do |field|
      should validate_presence_of(field)
    end
  end
end