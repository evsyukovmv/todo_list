FactoryGirl.define do
  factory :task do
    sequence(:name) { |n| "Task_#{n}" }
    description "Description"
    state "not_done"
    priority 1
  end
end