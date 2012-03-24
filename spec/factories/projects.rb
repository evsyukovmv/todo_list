FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project_#{n}" }
    description "Description"
  end
end