FactoryGirl.define do
  factory :task_list do
    sequence(:name) { |n| "Task_list_#{n}" }
    description "Description"
  end
end