require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower) }
  it { should belong_to(:followed) }
  it { should belong_to(:projects) }

  it "should have follower, followed and project" do
    [:follower_id, :followed_id, :project_id].each do |field|
      should validate_presence_of(field)
    end
  end
end